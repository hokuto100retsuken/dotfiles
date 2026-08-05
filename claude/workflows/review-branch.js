export const meta = {
  name: 'review-branch',
  description: '現ブランチの差分を観点別に並列レビューし、各指摘を別エージェントが反証してから返す',
  whenToUse:
    'PR作成前・レビュー依頼前に差分を厚く見たいとき。pre-pr-check.sh が機械判定する項目（文字化け・TODO残骸・lint 等）ではなく、' +
    '仕様ズレ・既存機能への副作用・nil前提・対称性のような「判断が必要で、実際に人間レビュアーから繰り返し指摘されている」観点を見る。',
  phases: [
    { title: 'レビュー', detail: '観点ごとに並列でレビュー' },
    { title: '検証', detail: '各指摘を反証しにいき、生き残ったものだけ残す' },
  ],
}

const base = (args && args.base) || 'master'

// pr-review-lessons（直近40PR・レビューコメント79件から抽出）のうち、
// 機械判定できず判断が必要なカテゴリを観点にする。
// 機械判定できるものは pre-pr-check.sh 側が見ているのでここでは扱わない。
const DIMENSIONS = [
  {
    key: 'spec',
    agentType: 'spec-checker',
    prompt:
      '実装が仕様・合意事項と一致しているかだけを見る。これがレビューで最も多い指摘。\n' +
      '- 判定条件を仕様と1対1で突き合わせる\n' +
      '- 状態・ステータスの分類は全パターン列挙して照合する（どちらにも入りうる状態を残さない）\n' +
      '- 判定の粒度（ショップ単位か種別単位か等）を確認する\n' +
      '- issue のコメント履歴を遡り、過去に合意された例外が反映されているか確認する\n' +
      '- 画面文言・メール文面は草案と一字一句照合する',
  },
  {
    key: 'side-effect',
    prompt:
      '既存機能への副作用だけを見る。実害級の指摘が出た領域。\n' +
      '- この変更で消える/上書きされるデータはないか\n' +
      '- 継続するはずの機能が壊れないか（実績: 連携失敗時にベーシックで継続するはずが pixel_id とトラッキングタグが削除されていた）\n' +
      '- リセット処理が「消してはいけないもの」まで消していないか',
  },
  {
    key: 'nil-count',
    prompt:
      'nil・0件・複数件の前提だけを見る。\n' +
      '- null 許容の必然性が本当にあるか（実績: plan が null で本文が「プラン：」と空欄になる）\n' +
      '- where で複数件取る前提が実態と合っているか\n' +
      '- 「あり得ない」ケースを握りつぶしていないか。fail-fast にすべきでないか',
  },
  {
    key: 'symmetry',
    prompt:
      '実装とテストの対称性だけを見る。\n' +
      '- 同型の処理が複数ある場合、実装もテストも全部に反映されているか（実績: 4つのメーラーのうち1つにだけテストを足していた）\n' +
      '- 片方だけ直していないか\n' +
      '- 変更の背景・理由がコードコメントとPR本文の両方に書かれているか',
  },
]

const FINDINGS_SCHEMA = {
  type: 'object',
  properties: {
    findings: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          title: { type: 'string', description: '指摘を1文で' },
          location: { type: 'string', description: 'file.rb:123 形式' },
          detail: { type: 'string', description: '何がどうズレているか' },
          severity: { type: 'string', enum: ['high', 'medium', 'low'] },
          needsHumanDecision: {
            type: 'boolean',
            description: '仕様の確認が必要で、こちらで決められない指摘か',
          },
        },
        required: ['title', 'location', 'detail', 'severity', 'needsHumanDecision'],
        additionalProperties: false,
      },
    },
  },
  required: ['findings'],
  additionalProperties: false,
}

const VERDICT_SCHEMA = {
  type: 'object',
  properties: {
    refuted: { type: 'boolean', description: '指摘が誤りなら true' },
    reason: { type: 'string' },
  },
  required: ['refuted', 'reason'],
  additionalProperties: false,
}

// 1観点あたりの検証本数の上限。超えた分は検証せず、log で明示する（黙って切らない）。
const VERIFY_LIMIT = 2

phase('レビュー')
log(`${base} との差分を ${DIMENSIONS.length} 観点で並列レビューします`)

const perDimension = await pipeline(
  DIMENSIONS,
  (d) =>
    agent(
      `\`git diff ${base}...HEAD\` の差分をレビューする。以下の観点だけを見る。他の観点は他のエージェントが担当するので触れない。\n\n` +
        `## 観点\n${d.prompt}\n\n` +
        `## 守ること\n` +
        `- コードが動くかは見ない。仕様と合っているか・既存を壊していないかを見る\n` +
        `- 指摘には必ず file:line を付ける\n` +
        `- 憶測で指摘を作らない。確信が持てないものは needsHumanDecision=true にする\n` +
        `- 指摘が無ければ findings を空配列で返す`,
      {
        label: `レビュー:${d.key}`,
        phase: 'レビュー',
        agentType: d.agentType,
        schema: FINDINGS_SCHEMA,
      }
    ),
  (review, d) => {
    const all = (review && review.findings) || []
    if (all.length > VERIFY_LIMIT) {
      log(`※ 観点 ${d.key}: ${all.length}件のうち重要度上位 ${VERIFY_LIMIT}件のみ検証します（残り ${all.length - VERIFY_LIMIT}件は未検証）`)
    }
    const order = { high: 0, medium: 1, low: 2 }
    const target = all
      .slice()
      .sort((a, b) => order[a.severity] - order[b.severity])
      .slice(0, VERIFY_LIMIT)

    return parallel(
      target.map((f) => () =>
        agent(
          `次のレビュー指摘が誤りであることを示そうとせよ。指摘を擁護するのではなく反証するのが役目。\n\n` +
            `## 指摘\n${f.title}\n場所: ${f.location}\n内容: ${f.detail}\n\n` +
            `## 判断基準\n` +
            `- 実際にコードを読み、指摘が事実誤認なら refuted=true\n` +
            `- 仕様の確認が必要で真偽が決まらない場合は refuted=false（人間の判断に回す）\n` +
            `- 迷ったら refuted=true に寄せる（誤検出を通すより落とす）`,
          { label: `検証:${d.key}`, phase: '検証', schema: VERDICT_SCHEMA }
        ).then((v) => ({ ...f, dimension: d.key, verdict: v }))
      )
    )
  }
)

const verified = perDimension.flat().filter(Boolean)
const confirmed = verified.filter((f) => f.verdict && !f.verdict.refuted)
const dropped = verified.filter((f) => f.verdict && f.verdict.refuted)

log(`検証通過 ${confirmed.length}件 / 反証により棄却 ${dropped.length}件`)

const order = { high: 0, medium: 1, low: 2 }
return {
  base,
  confirmed: confirmed.sort((a, b) => order[a.severity] - order[b.severity]),
  needsHumanDecision: confirmed.filter((f) => f.needsHumanDecision),
  droppedByVerification: dropped.map((f) => ({ title: f.title, reason: f.verdict.reason })),
}
