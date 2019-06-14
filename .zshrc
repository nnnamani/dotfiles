alias tm='tmux'
alias tmsessions='tmux list-sessions | peco --prompt '\''Session:'\'' | awk -F'\'':'\'' '\''{print $1}'\'''
alias tma='tmux attach-sessio -t $(tmsessions)'
alias tms='tmux switch-client -t $(tmsessions)'
alias tmk='tmux kill-session -t $(tmsessions)'

# if [ $SHLVL = 1 ]; then
#     if [ $(tmux list-sessions | awk -F':' '{print $1}' | wc -l | awk '{print $1}') -eq 0 ]; then
#         tmux
#     else
#         tma
#     fi
# fi

export TERM="xterm-256color"
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# Ctrl+Dでログアウトしてしまうことを防ぐ
setopt IGNOREEOF

# 日本語を使用
export LANG=ja_JP.UTF-8

# パスを追加したい場合
export PATH="$HOME/bin:$PATH"

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

alias repos='ghq list -p | peco'
alias cdrepos='cd $(repos)'
alias lst='ls -ltr --color=auto'
alias l='ls -ltr --color=auto'
alias la='ls -la --color=auto'
alias ll='ls -l --color=auto'
alias so='source'
alias v='vim'
alias vi='vim'
alias vz='vim ~/.zshrc'
alias c='cdr'
# historyに日付を表示
alias h='fc -lt '%F %T' 1'
alias cp='cp -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias ..='c ../'
alias back='pushd'
alias diff='diff -U1'
alias sz='source ~/.zshrc'
alias chrome='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias julia='/Applications/Julia-1.1.app/Contents/Resources/julia/bin/julia'
alias gpg="LANG=en_US.utf-8 gpg"
alias disable_mac_keyboard="sudo kextunload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"
alias enable_mac_keyboard="sudo kextload /System/Library/Extensions/AppleUSBTopCase.kext/Contents/PlugIns/AppleUSBTCKeyboard.kext/"

# mount conoha home
alias mch='sshfs conoha:/home/nnnamani ~/conoha/nnnamani'
alias cdch='cd ~/conoha/nnnamani'
alias firefox="open /Applications/Firefox.app"

# backspace,deleteキーを使えるように
stty erase ^H
bindkey "^[[3~" delete-char

# cdの後にlsを実行
# chpwd() { ls -ltr }

# どこからでも参照できるディレクトリパス
cdpath=(~)

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

# Ctrl+rでヒストリーのインクリメンタルサーチ、Ctrl+sで逆順
## peco
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi

    BUFFER=$(\history -n 1 | \
        eval $tac | \
        awk '!a[$0]++' | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

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
function mkcd() {
  if [[ -d $1 ]]; then
    echo "$1 already exists!"
    cd $1
  else
    mkdir -p $1 && cd $1
  fi
}

# Ruby
export PATH=$HOME/.rbenv/bin:$PATH
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Node.js
export PATH=$PATH:/Users/mani/.nodebrew/current/bin


# Roswell
export PATH=/Users/mani/.roswell/bin:/Users/mani/.roswell/bin:$PATH



zplug zsh-users/zsh-autosuggestions
zplug zsh-users/zsh-completions
zplug zsh-users/zsh-syntax-highlighting
#zplug mafredri/zsh-async, from:github
#zplug sindresorhus/pure, use:pure.zsh, from:github, as:theme

zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs newline)


if [ -e ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi


# install zsh plugins with zplug.
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load
export PATH=/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin:/Users/mani/.roswell/bin:/Users/mani/.roswell/bin:/Users/yujisuzuki/.rbenv/shims:/Users/yujisuzuki/.rbenv/bin:/Users/yujisuzuki/bin:/usr/local/Cellar/zplug/2.4.2/bin:/usr/local/opt/zplug/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin:/Users/mani/.roswell/bin:/Users/yujisuzuki/.rbenv/shims:/Users/yujisuzuki/.rbenv/bin:/Users/yujisuzuki/bin:/Users/mani/.nodebrew/current/bin:/usr/local/mysql/bin:/Users/mani/.nodebrew/current/bin:/usr/local/mysql/bin:~/.roswell/bin
