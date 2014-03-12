alias ls='ls --color=auto'
alias ll='ls -alF'
alias grep='grep --color=auto'

umask 0022

function parse-git-branch() {
    br=$(git branch 2> /dev/null | grep ^\* | cut -c3-)
    test -n "$br" && echo -n "($br)"
}

PS1="[\u@\h]\$(parse-git-branch):\w \$ "
