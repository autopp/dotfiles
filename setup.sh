#!/bin/bash

set -eu

function backup() {
  if [[ -e $1  ]]; then
    mv "$1" "$1".old
  fi
}

dir=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)

# Setup zsh
# backup .zshrc
backup ~/.zshrc

# Install oh-my-zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
  git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
cp kphoen-autopp.zsh-theme ~/.oh-my-zsh/themes

# Fix default .zshrc
sed -i -e 's|source $ZSH/oh-my-zsh.sh|ZSH_THEME="kphoen-autopp"\
source $ZSH/oh-my-zsh.sh|g' ~/.zshrc
echo "source ${dir}/.zshrc" >> ~/.zshrc
echo "# Environment specific configuration" >> ~/.zshrc

# Setup vim
backup ~/.vimrc
echo "source ${dir}/.vimrc" > ~/.vimrc

# Setup git
backup ~/.gitconfig
cat > ~/.gitconfig <<EOS
[include]
  path = ${dir}/.gitconfig
EOS
