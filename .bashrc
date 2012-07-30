# uncomment next line for debugging
#set -x
BLACK="\[\033[0;30m\]"
BLUE="\[\033[0;34m\]"
GREEN="\[\033[0;32m\]"
CYAN="\[\033[0;36m\]"
RED="\[\033[0;31m\]"
PURPLE="\[\033[0;35m\]"
YELLOW="\[\033[0;33m\]"
GREY="\[\033[0;37m\]"
BLACKB="\[\033[1;30m\]"
BLUEB="\[\033[1;34m\]"
BROWN="\[\033[1;32m\]"
CYANB="\[\033[1;36m\]"
REDB="\[\033[1;31m\]"
PURPLEB="\[\033[1;35m\]"
BROWNB="\[\033[1;33m\]"
GREYB="\[\033[1;37m\]"
NONE="\[\033[0m\]"
export EDITOR=vim
export MOZ_PRINTER_NAME=740p
unset MAIL

# If this is a non-interactive shell, we still want to get
# the stuff (like $PATH) in /etc/profile if we haven't already
if [[ -z "$Environ_Sourced" && -f /etc/profile ]]
then
  source /etc/profile
fi

if [ "$PS1" ]
then
    if [ -f ~/.bash_aliases ]
    then
  source ~/.bash_aliases
    fi

    # Turn on automatic directory spelling correction (for 'cd'),
    # checking for removed commands, and saving multi-line commands
    # on one line in the history
    shopt -s cdspell checkhash cmdhist 

    # Turn off HUP on exit, mail notification, and using $PATH for
    # the 'source' command
    shopt -u huponexit mailwarn sourcepath

    function prompt_command
    {
  if [ "$?" = 0 ]
  then
      ERRPROMPT=""
  else
      ERRPROMPT="($?)"
  fi
    }
    PROMPT_COMMAND=prompt_command
    # Put current user@machine:/directory on headline of xterms
    case $TERM in
        iris-ansi*|*xterm*)
      PS="${RED}\${ERRPROMPT}${BLUE}\!"
      if [ $UID = $EUID -a $UID -ne 0 ]
      then
    PS="${PS} ${BROWN}\h${BLUE}% ${NONE}"
      else
    PS="${PS} ${RED}\u@\h${BLUE}# ${NONE}"
      fi
      PS1="${PS}\[\e]2;\u@\h:\w\007\e]1;\u@\h\007\]"
            ;;
  default)
      if [ $UID = $EUID -a $UID -ne 0 ]
      then
    PS1="\${ERRPROMPT}\! \h$% "
      else
    PS1="\${ERRPROMPT}\! \u@\h$#"
      fi
    esac
fi

[[ -f ${HOME}/.bash_custom_settings ]] && . ${HOME}/.bash_custom_settings

alias gnuplot='rlwrap -a -c gnuplot'

export PS1="\[\e]2;\u@\H \w\a\e[32;1m\]\u@\H \[\e[36m\]\W \\$ \[\e[0m\]"

export PATH="${PATH}:${HOME}/gems/bin:${HOME}/usr/bin"

# Lets me install perl packages into my home directory (i.e. where I have write access)
# http://theoryx5.uwinnipeg.ca/CPAN/perl/lib/CPAN.html#faq
# 2010-10-26 11:55
export PERL5LIB="$HOME/myperl/lib"
export MANPATH="$MANPATH:$HOME/myperl/lib"

# Lets me install ruby gems into my home directory
# http://ianloic.com/2007/08/29/installing_ruby_gems_in_your_home_directory/
export GEM_HOME=/users/chogg/lib/ruby/gems/1.8
export RUBYLIB=/users/chogg/lib/ruby:/users/chogg/lib/site_ruby/1.8:/users/chogg/lib/rubygems:/users/chogg/lib

# Fonts in gnuplot
export GDFONTPATH=/usr/share/fonts/X11/misc:/usr/share/fonts/X11/100dpi:/usr/share/fonts/X11/75dpi:/usr/share/fonts/X11/Type1:/usr/share/fonts/X11/100dpi:/usr/share/fonts/X11/75dpi:/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType:/users/chogg/.fonts

export PYTHONPATH=/users/chogg/lib/python/
export PATH=$HOME/local/bin:$PATH
export PATH=$HOME/local/bin:$PATH
