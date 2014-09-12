# Clone from github repository
# 
# $ git clone git@github.com:autopp/dotfiles.git ~/dotfiles
# 
# Add to begin of your ~/.bashrc follow code:
# 
# if [[ -f ~/dotfiles/.bashrc ]]; then
#   . ~/dotfiles/.bashrc
# fi

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

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# setting pronpt
# check ruby is installed and prompt_option.rb is existed
which ruby > /dev/null && test -f prompt_option.rb

if [[ $? -eq 0 ]]; then
  PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\e[1;31m\][\u:\w] \$(./prompt_option.rb)\n\$\[\e[00m\] "
else 
  echo "ruby is not installed or prompt_option.rb is not fonud" 1>&2
  PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\e[1;31m\][\u:\w] \n\$\[\e[00m\] "
fi
