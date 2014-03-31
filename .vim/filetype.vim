if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  " Tab-delimited files go here.
  au BufNewFile,BufRead *.tab set noexpandtab
augroup END
