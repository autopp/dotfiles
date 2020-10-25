#!/bin/bash

set -eu
set -o pipefail

if !builtin command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
brew install coreutils curl exa gh git go hub jq kubectx kubernetes-cli nkf nodebrew peco tree wget zsh
