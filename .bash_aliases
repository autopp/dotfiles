# setting of command allias

alias cd='pushd > /dev/null'
alias chd='pushd ~ > /dev/null'
alias pop=popd
alias bd=popd
alias ls='ls -oal --color -F'
alias lal='ls -oal --color -F'
alias lla='ls -ola --color -F'

alias reflesh=". ${BASHRC}"

function mkcd() {
    if [[ $# -ne 1 ]]; then
        echo 'usage: mkcd dirname'
        return 1
    fi
    
    mkdir -p $1;
    local st=$?
    if [[ st -ne 0 ]]; then
        return $?
    fi
    
    cd $1;
}
