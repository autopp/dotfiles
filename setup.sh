#!/bin/bash

set -eu

function backup() {
  if [[ -e $1  ]]; then
    mv "$1" "$1".old
  fi
}

dir=$(dirname $0)

# Setup zsh
# backup .zshrc
backup ~/.zshrc

# Install oh-my-zsh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

# Fix default .zshrc
sed -i -e 's|source $ZSH/oh-my-zsh.sh|ZSH_THEME="kphoen"\
source $ZSH/oh-my-zsh.sh|g' ~/.zshrc
echo "source ${dir}/.zshrc" >> ~/.zshrc
echo "# Environment specific configuration" >> ~/.zshrc

# Setup vim
backup ~/.vimrc
echo "source ${dir}/.vimrc" > ~/.zshrc

# Setup git
backup ~/.gitconfig
cat > ~/.gitconfig <<EOS
[include]
  path = ${dir}/.gitconfig
EOS
