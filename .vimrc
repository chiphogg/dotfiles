" Charles Hogg's vimrc settings
"
" NOTE: As of November 2025, I am migrating to neovim and `init.lua`.  I will
" delete features from this file as I migrate them to the new file.
"
" For the remainder, I am commenting everything out so that it will be easy to
" find, but I won't see a ton of errors if I accidentally open vim out of habit.

"" vim-plug: the Right Way to manage Vim plugins ---------------------------{{{1
"
"call plug#begin('~/.vim/plugged')
"
"" Vim enhancements
"Plug 'altercation/vim-colors-solarized'
"Plug 'bling/vim-airline'
"Plug 'ConradIrwin/vim-bracketed-paste'
"Plug 'ntpeters/vim-better-whitespace'
"Plug 'tpope/vim-abolish'
"Plug 'tpope/vim-commentary'
"Plug 'tpope/vim-scriptease'
"Plug 'tpope/vim-sleuth'
"Plug 'tpope/vim-vinegar'
"Plug 'tyru/open-browser.vim'
"
"" Text objects (kana/vim-textobj-user is required by all the rest).
"Plug 'glts/vim-textobj-comment'
"Plug 'kana/vim-textobj-indent'
"Plug 'sgur/vim-textobj-parameter'
"
"" General Programming
"Plug 'chiphogg/vim-prototxt'
"Plug 'mrtazz/DoxygenToolkit.vim'
"Plug 'tpope/vim-endwise'
"Plug 'xolox/vim-easytags'
"Plug 'xolox/vim-misc'
"
"" Python
"Plug 'fisadev/vim-isort'
"Plug 'psf/black', {'branch': 'stable'}
"Plug 'tmhedberg/SimpylFold'
"
"" Markdown and markup
"Plug 'tpope/vim-markdown'
"
"" Other local-only plugins.
"if filereadable(expand("~/.local_plugins.vim"))
"  source ~/.local_plugins.vim
"endif
"
"call plug#end()
"
"" Basic settings ----------------------------------------------------------{{{1
"
"" Improving basic commands ---------------------------------------------{{{2
"
"" Refresh syntax highlighting <F12> ---------------------------------{{{3
"" Very handy when constructing a syntax file!
"nnoremap <silent> <F12> :syntax clear \| syntax off \| syntax on<CR>
"
"" Windows, tabs, and buffers -------------------------------------------{{{2
"
"" Text formatting ------------------------------------------------------{{{2
"
"" Unfortunately, visible tabs require 'list', which makes soft word wrap behave
"" badly.  So it should be toggleable.
"noremap <F8> :call List_toggle()<CR>
"noremap! <F8> <Esc>:call List_toggle()<CR>a
"" Telling the user whether "list mode" is on/off is not very informative.
"" Instead, say exactly which feature they gained, and exactly which one they
"" lost, by choosing this mode:
"func! List_toggle()
"  set list!
"  let l:list_feat = "Showing Tabs"
"  let l:nolist_feat = "Wrapping Words"
"  echo (&list ? l:list_feat : l:nolist_feat)."! (but not ".
"        \ (&list ? l:nolist_feat : l:list_feat).")"
"endfunc
"
"" Folding --------------------------------------------------------------{{{2
"
"" Miscellaneous settings -----------------------------------------------{{{2
"
"" Occasionally useful, but mainly too annoying.
"set completeopt-=preview
"
"" Disable the bell
"set vb t_vb=""
"
"" Disable scrollbars.
"set guioptions-=r
"
"" Persistent undo; see: https://advancedweb.hu/2017/09/19/vim-persistent-undo/
"let s:undo_dir = '/tmp/.vim-undo-dir'
"if (!isdirectory(s:undo_dir))
"  call mkdir(s:undo_dir, 'p', 0700)
"endif
"execute 'set undodir=' . s:undo_dir
"set undofile
"
"" Plugin settings ---------------------------------------------------------{{{1
"
"" airline --------------------------------------------------------------{{{2
"" Use powerline symbols.
"let g:airline_powerline_fonts = 1
"
"" coc.nvim -------------------------------------------------------------{{{2
"
"" Add a keyboard shortcut to populate location list with current diagnostics.
"nnoremap <Leader>cd :CocDiagnostics<CR>:lclose<CR>
"
"" Use tab for trigger completion with characters ahead and navigate.
"" (This whole section is copy-pasted from coc's homepage.)
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction
"
"" Jump to definition/declaration.
"nnoremap <silent> gd :call CocAction('jumpDefinition')<cr>
"nnoremap <silent> gD :call CocAction('jumpDeclaration')<cr>
"nnoremap <silent> gr :call CocAction('jumpReferences')<cr>
"nnoremap <silent> gs :CocList symbols<cr>
"
"" codefmt --------------------------------------------------------------{{{2
"" Enable mappings.
"Glaive codefmt plugin[mappings]
"
"" easytags -------------------------------------------------------------{{{2
"
"" Make all tag files local to each project, rather than global.
"set tags=./.tags;
"let g:easytags_dynamic_files = 2
"
"" fugitive -------------------------------------------------------------{{{2
"
"" :Ggrep the word under the cursor (populates quickfix list).
"nnoremap <silent> <LocalLeader>gg :GitGrepWordUnderCursor<CR>
"command! -nargs=0 GitGrepWordUnderCursor call s:GitGrepWordUnderCursorImpl()
"function! s:GitGrepWordUnderCursorImpl()
"  let l:word = escape(expand('<cword>'), '#')
"  execute "Ggrep '\\b" . l:word . "\\b'"
"endfunction
"
"" open-browser ---------------------------------------------------------{{{2
"" netrw already uses this mapping; disable it.
"let g:netrw_nogx = 1
"nmap gx <Plug>(openbrowser-open)
"vmap gx <Plug>(openbrowser-open)
"
"" Experimental command to help me enter the flow state.
"nnoremap ,foc :Focus<CR>a
"command -nargs=0 Focus setfiletype markdown | normal! Ofocus
"
"" unimpaired -----------------------------------------------------------{{{2
"
"" Use the old `co` mappings instead of the new `yo` mappings.
""
"" I use `coh` the most frequently, by far, and it's easier to type quickly and
"" correctly than `yoh`.
""
"" See: https://github.com/tpope/vim-unimpaired/issues/150
"nmap co yo
"
"" Filetype settings (wrapped in an augroup for re-entrantness) ------------{{{1
"" NOTE: I should probably consider putting these in a full-fledged ftplugin!
"
"augroup vimrc_filetypes
"  autocmd!
"  " python ---------------------------------------------------------------{{{2
"  autocmd BufWritePre *.py execute ':Black'
"
"  " sh -------------------------------------------------------------------{{{2
"  autocmd BufEnter /tmp/bash-fc-* setfiletype sh
"
"  " TeX-type files -------------------------------------------------------{{{2
"
"  " TeX + git: put each sentence on its own line(s) so the diffs are nicer.
"  autocmd FileType tex,rnoweb setl textwidth=0
"
"" augroup END ----------------------------------------------------------{{{2
"augroup END
"
"" Nanoc helpers -----------------------------------------------------------{{{1
"
"" The nanoc root at or above the given directory, or '' if none is found.
"function! s:NanocRoot(path)
"  let l:path_split = maktaba#path#Split(maktaba#path#GetDirectory(a:path))
"  while len(l:path_split) > 0
"    let l:dir = maktaba#path#Join(l:path_split)
"    if maktaba#path#Exists(maktaba#path#Join([l:dir, 'nanoc.yaml']))
"      return l:dir
"    endif
"    call remove(l:path_split, -1)
"  endwhile
"  return ''
"endfunction
"
"" Change to the nanoc root (if any), compile the website, and change back.
"function! s:CompileNanoc()
"  let l:cwd = getcwd()
"  let l:nanoc_dir = s:NanocRoot(l:cwd)
"  if empty(l:nanoc_dir)
"    call maktaba#error#Warn('Nanoc not found under "' . l:cwd . '"!')
"    return
"  endif
"  execute 'cd' l:nanoc_dir
"  !nanoc
"  execute 'cd' l:cwd
"endfunction
"
"command! -nargs=0 Nanoc call s:CompileNanoc()
"
"" Local settings ----------------------------------------------------------{{{1
"
"" We can put settings local to this particular machine in ~/.vimrc_local
"if filereadable(expand("~/.vimrc_local"))
"  source ~/.vimrc_local
"endif
"
"" Turn filetype back on ---------------------------------------------------{{{1
"" This goes at the end for speed reasons.
"filetype plugin indent on
"syntax on
"
"" Concealed characters are unreadable, so let's fix that.
