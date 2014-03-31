if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  " Tab-delimited files go here.
  au BufNewFile,BufRead *.tab set noexpandtab

  " It's much easier to write PhysicsForums code in vim, with UltiSnips.
  au BufNewFile,BufRead *.physicsforums set filetype=physicsforums
augroup END
