export PATH=$PATH:/usr/local/bin:$HOME/go/bin

export TERM="xterm-256color"
export ZPLUG_HOME=$HOME/dev/github.com/zplug/zplug/
source $ZPLUG_HOME/init.zsh

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

alias repos='ghq list -p | fzf'
alias cdrepos='cd $(repos)'
alias lst='ls -ltr --color=auto'
alias l='ls -ltr --color=auto'
alias la='ls -la --color=auto'
alias ll='ls -l --color=auto'
alias so='source'
alias v='vim'
alias vi='vim'
alias vz='vim ~/.zshrc'

# historyに日付を表示
alias cp='cp -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias back='pushd'
alias diff='diff -U1'
alias sz='source ~/.zshrc'
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'

if [ "$(uname)" = 'Darwin' ]; then
    alias julia='/Applications/Julia-1.3.app/Contents/Resources/julia/bin/julia'
fi

alias gpg="LANG=en_US.utf-8 gpg"
#alias fd=fdfind
alias disable_mac_keyboard="sudo kextunload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"
alias enable_mac_keyboard="sudo kextload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"

# emacs
alias em='emacsclient -a "" -nw'
alias show-colors='for c in {000..255}; do echo -n "\e[38;5;${c}m $c" ; [ $(($c%16)) -eq 15 ] && echo;done;echo'

# git utils
alias sb='git checkout $(git branch | grep -v "^*" | tr -d "[:blank:]" | fzf)'

alias killall_chrome='kill $(ps -ax | grep "Google Chrome" | grep -v "grep" | awk "{print $1}")'

alias git_add="git status -s | fzf -m | awk '{print \"git add \"\$2}' | sh"

eval "$(direnv hook zsh)"
chpwd() {
    if [ -e ./.envrc ]; then
        direnv allow .
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

export FZF_COMPLETION_TRIGGER=''
bindkey '^T' fzf-completion
bindkey '^I' $fzf_default_completion

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

# fzf-git-add
fzf-git-add() {
    git add $(git status -s | grep -v '^[M|A|D] ' | fzf -m --reverse | awk '{print $2}')
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

prompt() {
    local separator='%F{green}:%f'
    PROMPT_1="%m:%c`git-current-branch`"
    PROMPT_ARROW="%F{135}\U2771%f"
    print "%F{green}\U2772%f${PROMPT_1}%F{green}\U2773%f\n${PROMPT_ARROW} "
}

setopt prompt_subst
precmd() {
    PROMPT="`prompt`"
}

# プロンプト
git-current-branch() {
    local branch_name st branch_status

    if (git status |& grep 'fatal:'); then return; fi > /dev/null

    branch_name=`git rev-parse --abbrev-ref HEAD 2> /dev/null`
    after_status=''
    st=`git status 2> /dev/null`
    if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
        branch_status="%F{green}"
    elif [[ -n `echo "$st" | grep "^Untracked files"` ]]; then
        branch_status="%F{red}?"
    elif [[ -n `echo "$st" | grep "^Changes not staged for commit"` ]]; then
        branch_status="%F{red}+"
    elif [[ -n `echo "$st" | grep "^Changes to be committed"` ]]; then
        branch_status="%F{yellow}!"
    elif [[ -n `echo "$st" | grep "^rebase in progress"` ]]; then
        branch_status="%F{white}!"
        after_status="|rebase"
    elif [[ -n `echo "$st" | grep "^Unmerged paths"` ]]; then
        branch_status="%F{white}!"
        after_status="|merge"
    else
        branch_status="%F{blue}"
    fi
    echo ":${branch_status}${branch_name}${after_status}$(git-branch-status)"
}

function git-branch-status() {
    staged=`git status -s | grep -c '^[M|D] '`
    un_trace=`git status -s | grep -c '^??'`
    mod=`git status -s | grep -c '^ M'`
    del=`git status -s | grep -c '^ D'`
    if [ `expr $un_trace + $mod + $del` -gt 0 ]; then
        echo "%F{white}(%F{yellow}S:$staged|%F{green}M:$mod%F{white}|%F{blue}D:$del%F{white}|%F{magenta}N:$un_trace%F{white})"
    fi
}

# Use gnu readline.
export LDFLAGS="-L/usr/local/opt/readline/lib"
export CPPFLAGS="-I/usr/local/opt/readline/include"
export PKG_CONFIG_PATH="/usr/local/opt/readline/lib/pkgconfig"

#
# rbenv settings
#
export PATH=$PATH:$HOME/.rbenv/bin
eval "$(rbenv init -)"

# Node.js
export PATH=$PATH:$HOME/.nodebrew/current/bin

# Roswell
export PATH=$PATH:$HOME/.roswell/bin:$HOME/.roswell/bin

# Go
if which goenv > /dev/null; then eval "$(goenv init -)"; fi

# kubectl completion
source <(kubectl completion zsh)

# docker
fpath=(~/.zsh/completion $fpath)
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

zplug zsh-users/zsh-autosuggestions
zplug zsh-users/zsh-completions
zplug zsh-users/zsh-syntax-highlighting

if [ -e $HOME/.zshrc_local ]; then . $HOME/.zshrc_local; fi

# install zsh plugins with zplug.
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load
if [ -e /Users/yujisuzuki/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/yujisuzuki/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
