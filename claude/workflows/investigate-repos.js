export const meta = {
  name: 'investigate-repos',
  description: 'colorme の複数リポジトリを並列に横断調査して1つのレポートに統合する',
  whenToUse:
    '「全リポジトリで検索」「他のリポジトリにも同じパターンがあるか」など、調査範囲が複数リポジトリにまたがるとき。' +
    '単一リポジトリで足りる調査や単発の検索では使わない（researcher を1体起動するか、メインセッションで直接調べる）。',
  phases: [
    { title: '調査', detail: 'リポジトリごとに researcher を並列起動', model: 'sonnet' },
    { title: '統合', detail: '重複を除いて1つのレポートにまとめる' },
  ],
}

const ROOT = '~/src/git.pepabo.com/colorme'

// 調査対象のデフォルト。args.repos で上書きできる。
const DEFAULT_REPOS = [
  'colorme-api',
  'colorme-admin',
  'colorme-user',
  'colorme-cart',
  'colorme-umsys',
  'colorme-fixtures',
  'trunk',
]

const question = args && args.question
if (!question) {
  return { error: 'args.question に調査したい内容を渡してください' }
}

const repos = args && args.repos && args.repos.length ? args.repos : DEFAULT_REPOS

const FINDINGS_SCHEMA = {
  type: 'object',
  properties: {
    repo: { type: 'string', description: '調査したリポジトリ名' },
    found: { type: 'boolean', description: '該当が見つかったか' },
    summary: { type: 'string', description: '結論を3行以内で' },
    evidence: {
      type: 'array',
      description: '根拠。location は file.rb:123 形式',
      items: {
        type: 'object',
        properties: {
          location: { type: 'string' },
          note: { type: 'string' },
        },
        required: ['location', 'note'],
        additionalProperties: false,
      },
    },
    notFound: {
      type: 'array',
      description: '探したが無かった場所。推測で埋めずここに書く',
      items: { type: 'string' },
    },
    uncertain: {
      type: 'array',
      description: '判断が分かれる点。勝手に決めずここに残す',
      items: { type: 'string' },
    },
  },
  required: ['repo', 'found', 'summary', 'evidence'],
  additionalProperties: false,
}

phase('調査')
log(`${repos.length} リポジトリを並列調査します`)

const results = (
  await parallel(
    repos.map((repo) => () =>
      agent(
        `${ROOT}/${repo} の中だけを調べる。他のリポジトリは見ない。\n\n` +
          `## 調査内容\n${question}\n\n` +
          `## 守ること\n` +
          `- 見つからなければ found=false とし、探した場所を notFound に列挙する\n` +
          `- 推測で埋めない。「おそらく」で結論を作らない\n` +
          `- evidence の location は file.rb:123 形式にする\n` +
          `- 1件見つけて終わりにせず、同種のものを全部列挙する\n` +
          `- 構文単位の列挙には ast-grep を使う（grep は文字列一致で誤検出する）`,
        {
          label: `調査:${repo}`,
          phase: '調査',
          agentType: 'researcher',
          schema: FINDINGS_SCHEMA,
        }
      )
    )
  )
).filter(Boolean)

const hit = results.filter((r) => r.found)
const missed = repos.length - results.length
if (missed > 0) log(`※ ${missed} リポジトリは調査に失敗しました（結果に含まれません）`)
log(`調査完了 ${results.length} / 該当 ${hit.length}`)

if (hit.length === 0) {
  return {
    question,
    repos,
    found: false,
    searchedButNotFound: results.flatMap((r) => r.notFound || []),
    uncertain: results.flatMap((r) => r.uncertain || []),
  }
}

phase('統合')
const report = await agent(
  `以下は複数リポジトリを並列調査した結果(JSON)。これを1つの日本語レポートにまとめる。\n\n` +
    `## 守ること\n` +
    `- 結論を先に3行以内で書く\n` +
    `- 根拠の location は改変せずそのまま残す\n` +
    `- リポジトリ間で共通のパターンと、1つだけ違う箇所を区別して書く\n` +
    `- uncertain（判断が必要な点）は削らず残す。勝手に結論にしない\n` +
    `- 調査結果に無い情報を足さない\n\n` +
    JSON.stringify(hit, null, 2),
  { label: '統合', phase: '統合' }
)

return {
  question,
  repos,
  found: true,
  hitRepos: hit.map((r) => r.repo),
  uncertain: hit.flatMap((r) => r.uncertain || []),
  report,
}
