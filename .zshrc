if [[ -n "${ZPROF}" ]]; then
  zmodload zsh/zprof && zprof
fi

source ~/.zplugin/bin/zplugin.zsh

autoload -Uz compinit
compinit

zplugin load zsh-users/zsh-completions

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

# Completion
# <Tab> でパス名の補完候補を表示したあと、
# 続けて <Tab> を押すと候補からパス名を選択できるようになる
# 候補を選ぶには <Tab> か Ctrl-N,B,F,P
zstyle ':completion:*:default' menu select=1

# 単語の一部として扱われる文字のセットを指定する
# ここではデフォルトのセットから / を抜いたものとする
# こうすると、 Ctrl-W でカーソル前の1単語を削除したとき、 / までで削除が止まる
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

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
if builtin command -v exa >/dev/null 2>&1; then
  alias ls='exa -alb'
elif [[ $(uname) = 'Darwin' ]]; then
  alias ls='ls -oalh -G -F'
else
  alias ls='ls -oalh --color -F'
fi

alias brspec='bundle exec rspec'
alias brubocop='bundle exec rubocop'
alias brails='bundle exec rails'
alias brake='bundle exec rake'
alias bexec='bundle exec'

alias rm='rm -i'

# rbenv
if [[ -d "${HOME}/.rbenv" ]]; then
  export PATH="${HOME}/.rbenv/bin:${PATH}"
  eval "$(rbenv init --no-rehash - zsh)"
fi

if builtin command -v go >/dev/null 2>&1; then
  export PATH="${HOME}/go/bin:${PATH}"
fi

# nodebrew
if [[ -d "${HOME}/.nodebrew" ]]; then
  export PATH="${HOME}/.nodebrew/current/bin:$PATH"
fi

# go
if builtin command -v go >/dev/null 2>&1; then
  export GOPATH=${HOME}/go
fi

# rust
if [[ -d "$HOME/.cargo" ]]; then
  source $HOME/.cargo/env
fi

# theme
zplugin snippet OMZ::lib/git.zsh
zplugin snippet OMZ::plugins/git/git.plugin.zsh
zplugin cdclear -q
setopt promptsubst
autoload -Uz colors && colors
zplugin snippet ${HOME}/dotfiles/kphoen-autopp.zsh-theme

# ghq
if builtin command -v ghq >/dev/null 2>&1; then
  GHQ_ROOT_DIR=$(ghq root)
fi

# openapi-generator
if [[ -n "${GHQ_ROOT_DIR}" ]]; then
  alias openapi-generator-cli="java -jar '${GHQ_ROOT_DIR}/github.com/OpenAPITools/openapi-generator/modules/openapi-generator-cli/target/openapi-generator-cli.jar'"
fi

# ghq & peco
function repo() {
  local r
  r=$(ghq list -p --vcs=git | sed -e "s|^${HOME}/||g" | peco --query="$*")
  if [[ -z "$r" ]]; then
    return
  fi
  echo ${HOME}/$r
}

function gotorepo() {
  local r=$(repo $*)
  if [[ -z "$r" ]]; then
    return
  fi
  cd ${r}
}

function coderepo() {
  local r=$(repo $*)
  if [[ -z "$r" ]]; then
    return
  fi
  code ${r}
}

if [[ -n "${GHQ_ROOT_DIR}" ]]; then
  hash -d github.com="${GHQ_ROOT_DIR}/github.com"
fi

# hub
if builtin command -v hub >/dev/null 2>&1; then
  alias git=hub
fi

function show-pr() {
  line=$(hub pr list $* | peco)
  if [[ -n "$line" ]]; then
    hub pr show "$(echo $line | awk '{ print $1; }' | tr -d '#')"
  fi
}

# k8s
if builtin command -v kubectl >/dev/null 2>&1; then
  alias k=kubectl
fi

if builtin command -v kubectx >/dev/null 2>&1; then
  alias kx=kubectx
fi

# local settings
if [[ -f ~/.local.zsh ]]; then
  source ~/.local.zsh
fi

# パスの重複を削除する
typeset -U path cdpath fpath manpath

if builtin command -v zprof >/dev/null; then
  zprof
fi
