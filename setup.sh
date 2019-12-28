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

# Setup peco
backup ~/.peco/config.json
mkdir -p ~/.peco
cp ${dir}/peco.json ~/.peco/config.json

# Setup vim
backup ~/.vimrc
echo "source ${dir}/.vimrc" > ~/.vimrc

# Setup git
backup ~/.gitconfig
cat > ~/.gitconfig <<EOS
[include]
  path = ${dir}/.gitconfig
EOS

# setup rbenv
if [[ ! -e ~/.rbenv ]]; then
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  mkdir -p ~/.rbenv/plugins
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
fi

# Setup rubocop
backup ~/.rubocop.yml
ln -s ${dir}/.rubocop.yml ~/.rubocop.yml

# Setup GOPATH
mkdir -p ~/go/{src,bin,pkg}

# Setup ghq
mkdir -p ~/.ghq
