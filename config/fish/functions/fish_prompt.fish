function fish_prompt
    set -l last_status $status
    set -l prompt_char "❯"
    
    # Git Branch
    set -l git_branch (git branch --show-current 2>/dev/null)
    set -l project_name (basename (pwd))
    
    # --- Line 1: Rich Info ---
    
    # Project Name (blue)
    set_color 78a9ff # blue from carbonfox
    echo -n "$project_name"
    
    # Git Info (yellow)
    if test -n "$git_branch"
        set -l git_user (git config user.name 2>/dev/null)
        if test -n "$git_user"
            set_color ffc0b9 # coral/peach from carbonfox
            echo -n " as $git_user"
        end
        
        set_color 08bdba # yellow/teal from carbonfox
        echo -n " on  $git_branch"
        
        # Git Status indicators
        set -l git_status (git status --porcelain 2>/dev/null)
        if test -n "$git_status"
            set_color 08bdba
            echo -n " [\$]"
        end
    end

    # Docker / Colima (via 🐳 colima)
    # `colima status` はdaemon問い合わせで遅いので、socketの存在で稼働判定する
    if test -S "$HOME/.colima/default/docker.sock"
        set_color 6e6f70 # subtext/brblack
        echo -n " via 🐳 colima"
    end

    # Package Version (is 📦 v1.0.0)
    if test -f package.json
        set -l pkg_v (jq -r '.version' package.json 2>/dev/null)
        if test -n "$pkg_v"; and test "$pkg_v" != "null"
            set_color be95ff # mauve
            echo -n " is 📦 v$pkg_v"
        end
    end

    # Dockerプロジェクトはコンテナ内の実行版がホストからは見えないので、
    # 版表示を抑制して🐳バッジだけ出す
    set -l is_dockerized 0
    if test -f docker-compose.yml; or test -f docker-compose.yaml; or test -f compose.yaml; or test -f compose.yml; or test -f Dockerfile
        set is_dockerized 1
        set_color 33b1ff # blue (carbonfox)
        echo -n " 🐳 dockerized"
    end

    # Node.js版はリポジトリの版ファイルから読む（`node -v`はshim経由で遅い & Docker時は不正確）
    if test $is_dockerized -eq 0; and begin; test -f package.json; or test -d node_modules; end
        set -l node_v ""
        if test -f .nvmrc
            set node_v (string trim (cat .nvmrc))
        else if test -f .node-version
            set node_v (string trim (cat .node-version))
        else if test -f .tool-versions
            set node_v (awk '/^node / {print $2}' .tool-versions)
        end
        if test -n "$node_v"
            set_color 25be6a # green
            echo -n " via  v$node_v"
        end
    end

    # Ruby (via 💎 vX.X.X)
    # Ruby版もリポジトリの版ファイルから読む。Docker時は抑制
    if test $is_dockerized -eq 0; and begin; test -f Gemfile; or test -f Rakefile; end
        set -l ruby_v ""
        if test -f .ruby-version
            set ruby_v (string trim (cat .ruby-version))
        else if test -f .tool-versions
            set ruby_v (awk '/^ruby / {print $2}' .tool-versions)
        end
        test -z "$ruby_v"; and set ruby_v "?"
        set_color ee5396 # pink/red
        echo -n " via 💎 v$ruby_v"
    end

    # Command Duration (took Xs)
    if test $CMD_DURATION
        set -l duration_ms $CMD_DURATION
        if test $duration_ms -gt 1000
            set -l duration_s (math -s1 "$duration_ms / 1000")
            set_color c8a5ff # lavender
            echo -n " took $duration_s"s
        end
    end

    # --- Line 2: Prompt Character ---
    echo ""
    
    if test $last_status -eq 0
        set_color 25be6a # success green
    else
        set_color ee5396 # error red
    end
    
    echo -n "$prompt_char "
    set_color normal
end
