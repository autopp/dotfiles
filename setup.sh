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

# Install zplug
if [[ ! -d ~/.zplug ]]; then
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

ln -s ${dir}/.zshrc ~/.zshrc

# replace bash to zsh
backup ~/.bash_profile
cp ${dir}/.bash_profile ~/.bash_profile

# Setup vim
backup ~/.vimrc
echo "source ${dir}/.vimrc" > ~/.vimrc

# Setup nano
backup ~/.nanorc
cp ${dir}/.nanorc ~/.nanorc

# Setup git
backup ~/.gitconfig
cat > ~/.gitconfig <<EOS
[include]
  path = ${dir}/.gitconfig
EOS

# Setup rubocop
backup ~/.rubocop.yml
ln -s ${dir}/.rubocop.yml ~/.rubocop.yml
