" We need to wrap this in a 'readonly' conditional.  Otherwise, it gets hard
" to *edit* help files!
if &readonly == 1
  " Enter jumps to the option or help tag under the cursor.
  nnoremap <buffer> <silent> <CR> <C-]>

  " s/S navigates to next/previous help tag.
  nnoremap <buffer> <silent> s :call search('\|\zs\S\+\ze\|')<CR>
  nnoremap <buffer> <silent> S :call search('\|\zs\S\+\ze\|', 'b')<CR>

  " o/O navigates to next/previous option.
  nnoremap <buffer> <silent> o :call search("'".'\l\{2,\}'."'")<CR>
  nnoremap <buffer> <silent> O :call search("'".'\l\{2,\}'."'", 'b')<CR>

  " q quits the help buffer.
  " (What, did you think you'd be defining/using macros in help mode?)
  nnoremap <buffer> <silent> q :q<CR>
endif
