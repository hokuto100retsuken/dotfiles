#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd "$SCRIPT_DIR"

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ログ関数
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[⚠]${NC} $1"; }
error() { echo -e "${RED}[✗]${NC} $1"; }

# ヘルプ表示
show_help() {
    cat << EOF
dotfiles セットアップスクリプト

使い方:
    ./setup.sh [オプション]

オプション:
    -a, --all       すべてのセットアップを実行 (デフォルト)
    -i, --install   パッケージのインストールのみ
    -d, --dotfiles  dotfilesのシンボリックリンク作成のみ
    -f, --fish      fishシェルのプラグインインストールのみ
    --docker        Dockerのインストールのみ
    --interactive   インタラクティブモード（何を実行するか選択）
    -h, --help      このヘルプを表示

例:
    ./setup.sh              # すべてのセットアップを実行
    ./setup.sh --dotfiles   # dotfilesのリンクのみ作成
    ./setup.sh -i -d        # パッケージインストールとdotfilesのみ

EOF
}

# 確認プロンプト
confirm() {
    local message="$1"
    local default="${2:-N}"
    local prompt

    if [[ "$default" == "Y" ]]; then
        prompt="[Y/n]"
    else
        prompt="[y/N]"
    fi

    echo -ne "${YELLOW}$message $prompt ${NC}"
    read -r response
    response=${response:-$default}

    [[ "$response" =~ ^[Yy]$ ]]
}

# パッケージインストール
run_install() {
    info "パッケージのインストールを開始します..."
    if bash "$SCRIPT_DIR/setup-installs.sh"; then
        success "パッケージのインストールが完了しました"
        return 0
    else
        warn "パッケージのインストール中にエラーが発生しました"
        return 1
    fi
}

# dotfilesセットアップ
run_dotfiles() {
    info "dotfilesのシンボリックリンクを作成します..."
    if bash "$SCRIPT_DIR/setup-dotfiles.sh"; then
        success "dotfilesの設定が完了しました"
        return 0
    else
        error "dotfilesの設定中にエラーが発生しました"
        return 1
    fi
}

# fishセットアップ
run_fish() {
    info "fishシェルのプラグインをインストールします..."
    
    if ! command -v fish &> /dev/null; then
        warn "fishシェルがインストールされていません"
        echo "  先に 'setup.sh --install' を実行してfishをインストールしてください"
        return 1
    fi
    
    if bash "$SCRIPT_DIR/setup-fish.sh"; then
        success "fishシェルのセットアップが完了しました"
        return 0
    else
        error "fishシェルのセットアップ中にエラーが発生しました"
        return 1
    fi
}

# Dockerセットアップ
run_docker() {
    info "Dockerのインストールを開始します..."
    if bash "$SCRIPT_DIR/setup-docker.sh"; then
        success "Dockerのインストールが完了しました"
        return 0
    else
        error "Dockerのインストール中にエラーが発生しました"
        return 1
    fi
}

# すべて実行
run_all() {
    echo ""
    echo "=========================================="
    echo "dotfiles セットアップを開始します"
    echo "OS: $(uname -s) ($(uname -m))"
    echo "=========================================="
    echo ""
    
    local has_error=false
    
    # パッケージインストール
    if ! run_install; then
        if ! confirm "続行しますか？"; then
            error "セットアップを中断しました"
            exit 1
        fi
        has_error=true
    fi
    echo ""
    
    # dotfiles
    if ! run_dotfiles; then
        has_error=true
    fi
    echo ""
    
    # fish (fishがインストールされている場合のみ)
    if command -v fish &> /dev/null; then
        if ! run_fish; then
            has_error=true
        fi
        echo ""
    else
        warn "fishシェルが見つかりません。fishのセットアップをスキップします"
        echo ""
    fi
    
    echo "=========================================="
    if [[ "$has_error" == true ]]; then
        warn "セットアップが完了しましたが、一部エラーがありました"
    else
        success "セットアップが正常に完了しました！"
    fi
    echo "=========================================="
    echo ""
    echo "次のステップ:"
    echo "  1. ターミナルを再起動してください"
    echo "  2. fishシェルが起動することを確認してください"
    echo ""
}

# インタラクティブモード
run_interactive() {
    echo ""
    echo "=========================================="
    echo "dotfiles セットアップ (インタラクティブモード)"
    echo "OS: $(uname -s) ($(uname -m))"
    echo "=========================================="
    echo ""
    echo "実行するセットアップを選択してください:"
    echo ""
    
    local run_install_flag=false
    local run_dotfiles_flag=false
    local run_fish_flag=false
    local run_docker_flag=false
    
    if confirm "1. パッケージをインストールしますか？" "Y"; then
        run_install_flag=true
    fi
    
    if confirm "2. dotfilesのシンボリックリンクを作成しますか？" "Y"; then
        run_dotfiles_flag=true
    fi
    
    if confirm "3. fishシェルのプラグインをインストールしますか？" "N"; then
        run_fish_flag=true
    fi
    
    if confirm "4. Dockerをインストールしますか？" "N"; then
        run_docker_flag=true
    fi
    
    echo ""
    
    if [[ "$run_install_flag" == false ]] && \
       [[ "$run_dotfiles_flag" == false ]] && \
       [[ "$run_fish_flag" == false ]] && \
       [[ "$run_docker_flag" == false ]]; then
        warn "何も選択されていません。終了します"
        exit 0
    fi
    
    echo "=========================================="
    info "セットアップを開始します..."
    echo "=========================================="
    echo ""
    
    local has_error=false
    
    if [[ "$run_install_flag" == true ]]; then
        run_install || has_error=true
        echo ""
    fi
    
    if [[ "$run_dotfiles_flag" == true ]]; then
        run_dotfiles || has_error=true
        echo ""
    fi
    
    if [[ "$run_fish_flag" == true ]]; then
        run_fish || has_error=true
        echo ""
    fi
    
    if [[ "$run_docker_flag" == true ]]; then
        run_docker || has_error=true
        echo ""
    fi
    
    echo "=========================================="
    if [[ "$has_error" == true ]]; then
        warn "セットアップが完了しましたが、一部エラーがありました"
    else
        success "セットアップが正常に完了しました！"
    fi
    echo "=========================================="
}

# メイン処理
main() {
    # 引数がない場合はヘルプを表示してインタラクティブモードを提案
    if [[ $# -eq 0 ]]; then
        show_help
        echo ""
        if confirm "インタラクティブモードで続行しますか？" "Y"; then
            run_interactive
        else
            echo ""
            info "使用例: ./setup.sh --all"
        fi
        exit 0
    fi
    
    # フラグ初期化
    local do_install=false
    local do_dotfiles=false
    local do_fish=false
    local do_docker=false
    local do_all=false
    local do_interactive=false
    
    # 引数解析
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                show_help
                exit 0
                ;;
            -a|--all)
                do_all=true
                shift
                ;;
            -i|--install)
                do_install=true
                shift
                ;;
            -d|--dotfiles)
                do_dotfiles=true
                shift
                ;;
            -f|--fish)
                do_fish=true
                shift
                ;;
            --docker)
                do_docker=true
                shift
                ;;
            --interactive)
                do_interactive=true
                shift
                ;;
            *)
                error "不明なオプション: $1"
                echo ""
                show_help
                exit 1
                ;;
        esac
    done
    
    # 実行
    if [[ "$do_interactive" == true ]]; then
        run_interactive
        exit 0
    fi
    
    if [[ "$do_all" == true ]]; then
        run_all
        exit 0
    fi
    
    # 個別実行
    local has_error=false
    local ran_something=false
    
    if [[ "$do_install" == true ]]; then
        run_install || has_error=true
        ran_something=true
        echo ""
    fi
    
    if [[ "$do_dotfiles" == true ]]; then
        run_dotfiles || has_error=true
        ran_something=true
        echo ""
    fi
    
    if [[ "$do_fish" == true ]]; then
        run_fish || has_error=true
        ran_something=true
        echo ""
    fi
    
    if [[ "$do_docker" == true ]]; then
        run_docker || has_error=true
        ran_something=true
        echo ""
    fi
    
    if [[ "$ran_something" == false ]]; then
        warn "実行するタスクが指定されていません"
        show_help
        exit 1
    fi
    
    if [[ "$has_error" == true ]]; then
        exit 1
    fi
}

main "$@"
