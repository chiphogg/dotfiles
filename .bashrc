# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export EDITOR="gvim -f"

# Keep a rich command line history: store 20,000 lines on disk, and keep 5,000
# lines in memory.  Erase duplicates to save space.
export HISTSIZE=5000
export HISTFILESIZE=20000
export HISTCONTROL=erasedups
shopt -s histappend

# Don't match dotfiles with autocomplete
# (Unless, of course, you start by typing the dot)
bind 'set match-hidden-files off'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

[[ -f ~/.bash_custom_settings ]] && . ~/.bash_custom_settings

# If this is a non-interactive shell, we still want to get
# the stuff (like $PATH) in /etc/profile if we haven't already
if [[ -z "$Environ_Sourced" && -f /etc/profile ]]
then
  source /etc/profile
fi


# ghar setup (for synchronizing homedir stuff).
export GHAR_DIR="$HOME/tools/ghar"
export PATH="$PATH:$GHAR_DIR/bin/"
. "$GHAR_DIR/ghar-bash-completion.sh"

# Tweak path to include executable locations.
export PATH="$PATH:$HOME/.local/bin/"
export PATH="$PATH:$HOME/local/bin"
export PATH="$PATH:$HOME/bin/"

# Fixes errors like this one:
# WARNING **: Unable to create Ubuntu Menu Proxy: Timeout was reached
alias gvim='UBUNTU_MENUPROXY= gvim'

[[ -f ~/.bash_prompt ]] && . ~/.bash_prompt
