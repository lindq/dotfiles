export EDITOR="$HOME/bin/editor"
export HISTCONTROL=ignoreboth
export HISTFILESIZE=2000
export HISTSIZE=1000
export IGNOREEOF=2
export PATH="$HOME/bin:$PATH"
export PS1="[\u@\h]:\w \$ "

if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi
