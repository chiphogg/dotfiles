if [[ -f ~/.bashrc ]]
then
  source ~/.bashrc
fi
if [[ -f ~/.bash_complete && "${BASH_VERSINFO[0]}${BASH_VERSINFO[1]}" > 204 ]]
then
  source ~/.bash_complete
fi
export KDEWM=fluxbox
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
