if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  " when BufRead or BufNewFile event is triggered, pop off the .svn-base
  " extension and manually restart filetype autocommands
  au! BufRead    *.svn-base execute 'doau filetypedetect BufRead ' . expand('%:r')
  au! BufNewFile *.svn-base execute 'doau filetypedetect BufNewFile ' . expand('%:r')
  " For svn, I always keep changes in ".changes".  Formatting is MUCH nicer
  " with tabs expanded to spaces.
  au BufNewFile,BufRead .changes set expandtab
  au BufNewFile,BufRead .changes set autoindent
  " Today.viki is auto-updated
  au BufNewFile,BufRead Today.viki set autoread
  " tab-delimited files go here
  au BufNewFile,BufRead *.tab,timelog set noexpandtab
augroup END
