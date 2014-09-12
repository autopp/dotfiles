# Clone from github repository
# 
# $ git clone git@github.com:autopp/dotfiles.git ~/dotfiles
# 
# Add to begin of your ~/.bashrc follow code:
# 
# if [[ -f ~/dotfiles/.bashrc ]]; then
#   . ~/dotfiles/.bashrc
# fi
# 
# And also add to end of your ~/.bashrc follow code:
# 
# if [[ -f ~/dotfiles/.bash_prompt ]]; then
#   . ~/dotfiles/.bash_prompt
# fi
# 

# path of dotfiles directory
export DOTFILES=$(cd $(dirname $BASH_SOURCE); pwd)

# setting environment variables
if [[ -f ${DOTFILES}/.bash_env ]]; then
  . ${DOTFILES}/.bash_env
else
  echo "dotfiles/.bash_env is not found" 1>&2
fi

# setting aliases
if [[ -f ${DOTFILES}/.bash_aliases ]]; then
  . ${DOTFILES}/.bash_aliases
else
  echo "dotfiles/.bash_aliases is not found" 1>&2
fi

# setting rbenv
if [[ -d "${HOME}/.rbenv" ]]; then
  export PATH="${HOME}/.rbenv/bin:${PATH}"
  eval "$(rbenv init -)"
else
  echo "rbenv is not installed"
fi
