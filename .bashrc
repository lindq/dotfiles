case "$(uname)" in
    Linux)
            alias ls='ls --color=auto'
            ;;
    Darwin)
            alias ls='ls -G'
            ;;
esac

alias ll='ls -alF'
alias grep='grep --color=auto'
alias rmpyc='find . -name \*.pyc -exec rm {} \;'

umask 0022

function parse-git-branch() {
    br=$(git branch 2> /dev/null | grep ^\* | cut -c3-)
    test -n "$br" && echo -n "($br)"
}

PS1="\[\033[01;32m\][\u@\h]\[\033[00m\]\$(parse-git-branch):\[\033[01;34m\]\w\[\033[00m\] \$ "
