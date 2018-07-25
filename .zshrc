source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-completions"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin":${PATH}

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

# cd -<tab>で以前移動したディレクトリを表示
setopt auto_pushd

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

# rbenv
if [[ -d "${HOME}/.rbenv" ]]; then
  export PATH="${HOME}/.rbenv/bin:${PATH}"
  eval "$(rbenv init - zsh)"
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

# local settings
if [ -f ~/.local.zsh ]; then
  source ~/.local.zsh
fi

zplug load
