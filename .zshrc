export PATH=$PATH:/usr/local/bin:$HOME/go/bin

export TERM="xterm-256color"

# Ctrl+Dでログアウトしてしまうことを防ぐ
setopt IGNOREEOF

# 日本語を使用
export LANG=ja_JP.UTF-8

# パスを追加したい場合
export PATH=$PATH:$HOME/bin
export PATH=/usr/local/sbin:$PATH

# 色を使用
autoload -Uz colors
colors

# 補完
autoload -Uz compinit
compinit

# emacsキーバインド
bindkey -e

# 他のターミナルとヒストリーを共有
setopt share_history

# ヒストリーに重複を表示しない
setopt histignorealldups

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# 自動でpushdを実行
setopt auto_pushd

# pushdから重複を削除
setopt pushd_ignore_dups

# コマンドミスを修正
setopt correct

# グローバルエイリアス
alias -g L='| less'
alias -g H='| head'
alias -g G='| grep'
alias -g GI='| grep -ri'

alias lst='ls -ltr --color=auto'
alias l='ls -ltr --color=auto'
alias la='ls -la --color=auto'
alias ll='ls -l --color=auto'
alias so='source'
alias v='vim'
alias vi='vim'
alias vz='vim ~/.zshrc'


alias repos='ghq list -p | fzf'
alias cdrepos='cd $(repos)'


# historyに日付を表示
alias cp='cp -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias back='pushd'
alias diff='diff -U1'
alias sz='source ~/.zshrc'

if [ "$(uname)" = 'Darwin' ]; then
    alias julia='/Applications/Julia-1.3.app/Contents/Resources/julia/bin/julia'
    alias disable_mac_keyboard="sudo kextunload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"
    alias enable_mac_keyboard="sudo kextload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"
    alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
fi

alias gpg="LANG=en_US.utf-8 gpg"
alias fd=fdfind

# emacs
alias em='emacsclient -nw -a ""'
alias show-colors='for c in {000..255}; do echo -n "\e[38;5;${c}m $c" ; [ $(($c%16)) -eq 15 ] && echo;done;echo'

# git utils
alias sb='git checkout $(git branch | grep -v "^*" | tr -d "[:blank:]" | fzf)'

alias killall_chrome='kill $(ps -ax | grep "Google Chrome" | grep -v "grep" | awk "{print $1}")'

chpwd() {
    if [ -e ./.envrc ]; then
        direnv allow
    fi
}

# 区切り文字の設定
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars "_-./;@"
zstyle ':zle:*' word-style unspecified

# Ctrl+sのロック, Ctrl+qのロック解除を無効にする
setopt no_flow_control

# 補完後、メニュー選択モードになり左右キーで移動が出来る
zstyle ':completion:*:default' menu select=2

# 補完で大文字にもマッチ
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#source /usr/local/Cellar/fzf/0.20.0/shell/completion.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Ctrl+rでヒストリーのインクリメンタルサーチ、Ctrl+sで逆順
## fzf
fzf-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi

    BUFFER=$(\history -n 1 | \
                 eval $tac | \
                 awk '!a[$0]++' | \
                 fzf --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}

zle -N fzf-select-history
bindkey '^r' fzf-select-history

fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}

# find git project home
function cdgithome() {
    if [ -z "$1" ]; then
        current_dir="."
    else
        current_dir="$1"
    fi

    cd "$current_dir"

    if [ "$(pwd)" = "/" ]; then
        echo "Not Found"
        return 1
    elif [ -e ".git" ]; then
        pwd
    else
        githome ..
    fi
}

# コマンドを途中まで入力後、historyから絞り込み
# 例 ls まで打ってCtrl+pでlsコマンドをさかのぼる、Ctrl+bで逆順
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# cdrコマンドを有効 ログアウトしても有効なディレクトリ履歴
# cdr タブでリストを表示
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs
# cdrコマンドで履歴にないディレクトリにも移動可能に
zstyle ":chpwd:*" recent-dirs-default true

# 複数ファイルのmv 例　zmv *.txt *.txt.bk
autoload -Uz zmv
alias zmv='noglob zmv -W'

# mkdirとcdを同時実行
mkcd() {
    if [[ -d $1 ]]; then
        echo "$1 already exists!"
        cd $1
    else
        mkdir -p $1 && cd $1
    fi
}

# Use gnu readline.
export LDFLAGS="-L/usr/local/opt/readline/lib"
export CPPFLAGS="-I/usr/local/opt/readline/include"
export PKG_CONFIG_PATH="/usr/local/opt/readline/lib/pkgconfig"

# Node.js
export PATH=$PATH:$HOME/.nodebrew/current/bin

# Roswell
# nix-shell -p autoconf automake curl --command 'sh -c ".bootstrap && ./configure --prefix=$HOME/.roswell && make && make install"'
#export PATH=$PATH:$HOME/.roswell/bin

# Go
if type goenv >/dev/null 2>&1; then
    eval "$(goenv init -)";
fi

export PATH="$HOME/.cargo/bin:$PATH"

# kubectl completion
if type kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)
fi

# docker
fpath=(~/.zsh/completion $fpath)
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

export ZPLUG_HOME=$HOME/src/zplug/zplug/

if [ -e $ZPLUG_HOME/init.zsh ]; then
    source $ZPLUG_HOME/init.zsh
    zplug zsh-users/zsh-autosuggestions
    zplug zsh-users/zsh-completions
    zplug zsh-users/zsh-syntax-highlighting
    install zsh plugins with zplug.
    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi

    zplug load
fi

if [ -e $HOME/.zshrc_local ]; then
    source $HOME/.zshrc_local
fi

if [ -d $HOME/.anyenv ]; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
fi

#
# rbenv settings
#
export PATH=$PATH:$HOME/.rbenv/bin
if type rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)"
fi

# Initialize Starship
eval "$(starship init zsh)"
