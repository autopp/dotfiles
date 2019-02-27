source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-completions"

export PATH="${HOME}/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:"${PATH}

# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# cdなしでディレクトリ移動
setopt auto_cd

# =以降も補完する(--prefix=/usrなど)
setopt magic_equal_subst

# ビープ音の停止
setopt no_beep

# ビープ音の停止(補完時)
setopt nolistbeep

# 履歴の保存場所
HISTFILE=~/.zsh_history

# メモリ内の履歴の数
HISTSIZE=10000

# 保存される履歴の数
SAVEHIST=100000

# 履歴ファイルに時刻を記録
setopt extended_history

# cd -<tab>で以前移動したディレクトリを表示
setopt auto_pushd

# 複数の zsh を同時に使う時など history ファイルに上書きせず追加
setopt append_history

# コマンドが入力されるとすぐに追加
setopt inc_append_history

# 履歴をプロセス間で共有
setopt share_history

# Completion
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

# キーバインディングをemacs風に(-vはvim)
bindkey -e
bindkey ";5C" forward-word
bindkey ";5D" backward-word

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey "^[[Z" reverse-menu-complete

# 前回のコマンドの最後の引数挿入
bindkey '^]' insert-last-word

# Alias
alias bd=popd
alias mless='less +F'

if [[ $(uname) = 'Darwin' ]]; then
  alias ls='ls -oalh -G -F'
  alias lal='ls -oalh -G -F'
  alias lla='ls -olah -G -F'
else
  alias ls='ls -oalh --color -F'
  alias lal='ls -oalh --color -F'
  alias lla='ls -olah --color -F'
fi

alias brspec='bundle exec rspec'
alias brubocop='bundle exec rubocop'
alias brake='bundle exec rake'
alias brails='bundle exec rails'
alias bexec='bundle exec'

alias rm='rm -i'

# rbenv
if [[ -d "${HOME}/.rbenv" ]]; then
  export PATH="${HOME}/.rbenv/bin:${PATH}"
  eval "$(rbenv init - zsh)"
fi

# go
if [[ -d "${HOME}/go/bin"  ]]; then
  export PATH="${HOME}/go/bin:${PATH}"
fi

if [[ -d "${HOME}/.goenv" ]]; then
  export GOENV_ROOT="$HOME/.goenv"
  export PATH="$GOENV_ROOT/bin:$PATH"
  eval "$(goenv init -)"
fi

# nodebrew
if [[ -d "${HOME}/.nodebrew" ]]; then
  export PATH="${HOME}/.nodebrew/current/bin:$PATH"
fi

# theme
zplug "~/dotfiles", use:"kphoen-autopp.zsh-theme", from:local, as:theme, defer:3

if [ ! ~/.zplug/last_zshrc_check_time -nt ~/.zshrc ]; then
  touch ~/.zplug/last_zshrc_check_time
  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
      echo; zplug install
    fi
  fi
fi

# ghq & peco
function repo() {
  local r
  r=$(ghq list -p | sed -e "s|^${HOME}/||g" | peco --query="$*")
  if [ -z "$r" ]; then
    return
  fi
  echo ${HOME}/$r
}

function editrepo() {
  local r
  r=$(repo $*)
  if [ -z "$r" ]; then
    return
  fi
  cd ${r} && code ${r}
}

function gotorepo() {
  local r=$(repo $*)
  if [ -z "$r" ]; then
    return
  fi
  cd ${r}
}

function coderepo() {
  local r=$(repo $*)
  if [ -z "$r" ]; then
    return
  fi
  code ${r}
}

if which ghq >/dev/null 2>&1; then
  hash -d github.com="$(ghq root)/github.com"
fi

# hub
if which hub >/dev/null 2>&1; then
  alias git=hub
fi

# local settings
if [ -f ~/.local.zsh ]; then
  source ~/.local.zsh
fi

zplug load

compinit -u
