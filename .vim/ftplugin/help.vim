" We need to wrap this in a 'readonly' conditional.  Otherwise, it gets hard
" to *edit* help files!
if &readonly == 1
  nnoremap <buffer> <CR> <C-]>
  nnoremap <buffer> <BS> <C-T>
  nnoremap <buffer> o /'\l\{2,\}'<CR>
  nnoremap <buffer> O ?'\l\{2,\}'<CR>
  nnoremap <buffer> s /\|\zs\S\+\ze\|<CR>
  nnoremap <buffer> S ?\|\zs\S\+\ze\|<CR>
endif