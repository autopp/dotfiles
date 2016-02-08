# 文字コードの指定
export LANG=ja_JP.UTF-8

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# cdなしでディレクトリ移動
setopt auto_cd

# ビープ音の停止
setopt no_beep

# ビープ音の停止(補完時)
setopt nolistbeep

# cd -<tab>で以前移動したディレクトリを表示
setopt auto_pushd

# キーバインディングをemacs風に(-vはvim)
bindkey -e

# zsh-completionsの設定
fpath=(/path/to/homebrew/share/zsh-completions $fpath)

autoload -U compinit
compinit -u

alias brspec='bundle exec rspec'
alias brubocop='bundle exec rubocop'

# <Tab> でパス名の補完候補を表示したあと、
# 続けて <Tab> を押すと候補からパス名を選択できるようになる
# 候補を選ぶには <Tab> か Ctrl-N,B,F,P
zstyle ':completion:*:default' menu select=1

# 単語の一部として扱われる文字のセットを指定する
# ここではデフォルトのセットから / を抜いたものとする
# こうすると、 Ctrl-W でカーソル前の1単語を削除したとき、 / までで削除が止まる
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

## 重複パスを登録しない
typeset -U path cdpath fpath manpath

export EDITOR=vim
export PATH=$HOME/bin:$PATH

# コマンド履歴検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# 前回のコマンドの最後の引数挿入
bindkey "^." insert-last-word

# setting rbenv
if [[ -d "${HOME}/.rbenv" ]]; then
  export PATH="${HOME}/.rbenv/bin:${PATH}"
  eval "$(rbenv init - zsh)"
fi

alias bd=popd
alias mless='less +F'

if [[ $(uname) = 'Darwin' ]]; then
  alias ls='ls -oal -G -F'
  alias lal='ls -oal -G -F'
  alias lla='ls -ola -G -F'
else
  alias ls='ls -oal --color -F'
  alias lal='ls -oal --color -F'
  alias lla='ls -ola --color -F'
fi

# scalaenv の設定
if [[ -d ${HOME}/.scalaenv ]]; then
  export PATH="${HOME}/.scalaenv/bin:${PATH}"
  eval "$(scalaenv init -)"
fi
