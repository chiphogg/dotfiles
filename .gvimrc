set gfn=JetBrainsMono\ 10

" We have to disable the bell here too; it gets reset for gvim. See:
" http://stackoverflow.com/a/5933613
set vb t_vb=""

if filereadable(expand("~/.gvimrc_local"))
  source ~/.gvimrc_local
endif

