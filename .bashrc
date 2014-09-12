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

# setting environment variables
if [[ -f .bash_env ]]; then
  . bash_env
else
  echo "dotfiles/.bash_env is not found" 1>&2
fi

# setting aliases
if [[ -f .bash_aliases ]]; then
  . .bash_aliases
else
  echo "dotfiles/.bash_aliases is not found" 1>&2
fi
