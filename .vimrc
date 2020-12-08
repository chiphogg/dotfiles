" Charles Hogg's vimrc settings

" vim-plug: the Right Way to manage Vim plugins ---------------------------{{{1

call plug#begin('~/.vim/plugged')

" Vim enhancements
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'google/vim-searchindex'
Plug 'google/vim-syncopate'
Plug 'jlanzarotta/bufexplorer'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'tyru/open-browser.vim'

" Snippets.
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Text objects (kana/vim-textobj-user is required by all the rest).
Plug 'kana/vim-textobj-user'
Plug 'glts/vim-textobj-comment'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'sgur/vim-textobj-parameter'

" Git plugins
Plug 'tpope/vim-fugitive'

" General Programming
Plug 'chiphogg/vim-prototxt'
Plug 'chiphogg/vim-codefmt'
Plug 'mrtazz/DoxygenToolkit.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rking/ag.vim'
Plug 'tpope/vim-endwise'
Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'

" Python
Plug 'psf/black', {'tag': '19.10b0'}
Plug 'tmhedberg/SimpylFold'

" For maktaba-based plugins
Plug 'google/maktaba'
Plug 'google/glaive'

" Markdown and markup
Plug 'tpope/vim-markdown'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" My productivity system
Plug 'chiphogg/vim-vtd'

" Other local-only plugins.
if filereadable(expand("~/.local_plugins.vim"))
  source ~/.local_plugins.vim
endif

call plug#end()
call glaive#Install()

" Basic settings ----------------------------------------------------------{{{1

" ',' is easy to type, so use it for <Leader> to make compound commands easier:
let mapleader=","
" Unfortunately, this introduces a delay for the ',' command.  Let's compensate
" by introducing a speedy alternative...
noremap ,. ,

" Improving basic commands ---------------------------------------------{{{2

" Easy quit-all, which is unlikely to be mistyped.
nnoremap <silent> <Leader>qwer :confirm qa<CR>

" Y should work like D and C.
nnoremap Y y$

" Jumping to marks: You pretty much always want to jump to the cursor position
" (`), not the beginning of the line (').  But, the apostrophe is much more
" conveniently located.  So, save your fingers and swap 'em!
nnoremap ' `
nnoremap ` '

" Jump list navigation: Ctrl-O goes back, and Tab goes forward.  But Tab is
" *perfect* for navigating vimwiki links!
" MY solution: Use Ctrl-P to go forward.  P is to the right of O, so the
" mnemonic is (O, P) <-> (Left, Right) one jump
" (Btw, the default normal-mode Ctrl-P appears fairly useless: looks like a
" clone of 'k'.  So, we're not giving up much.)
noremap <C-P> <Tab>

" <C-U> can delete text which undo can't recover. These mappings prevent that.
" http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Some filetypes work best with 'nowrap'.  Vim moves left and right using zL
" and zH, but this is awkward.  ZL and ZH are easier alternatives.
nnoremap ZL zL
nnoremap ZH zH

" This makes it easier to tell when I hit the last search result.  In practice,
" I rarely want it to wrap around more than once, and 'gg' is easy enough.
set nowrapscan

" Easy Datestamp <F4> and timestamp <F5> ----------------------------{{{3
nnoremap <F4> "=strftime("%F")<CR>p
vnoremap <F4> "=strftime("%F")<CR>p
inoremap <F4> <C-R>=(strftime("%F"))<CR>
cnoremap <F4> <C-R>=(strftime("%F"))<CR>
nnoremap <F5> "=strftime("%R")<CR>p
vnoremap <F5> "=strftime("%R")<CR>p
inoremap <F5> <C-R>=(strftime("%R"))<CR>
cnoremap <F5> <C-R>=(strftime("%R"))<CR>

" Paste mode commands: toggle with <F7>; auto-turnoff; retroactive --{{{3

" Toggling with <F7> (simplified from http://www.bulheller.com/vimrc.html)
" Normal mode:
nnoremap <silent> <F7> :call Paste_toggle()<CR>
func! Paste_toggle()
  set paste!
  echo "Paste mode: ".(&paste ? "ON" : "OFF")
endfunc
" Insert mode:
set pastetoggle=<F7>

" Paste mode persists by default.  I don't recall ever *wanting* this to happen,
" but I *do* sometimes get burned by this.  The following autocommand prevents
" this from happening (wrapped in an augroup in case .vimrc gets reloaded).
augroup paste
  autocmd!
  autocmd InsertLeave * set nopaste
augroup END

" Refresh syntax highlighting <F12> ---------------------------------{{{3
" Very handy when constructing a syntax file!
nnoremap <silent> <F12> :syntax clear \| syntax off \| syntax on<CR>

" Windows, tabs, and buffers -------------------------------------------{{{2

" Let vim hide unsaved buffers.
set hidden

" Text formatting ------------------------------------------------------{{{2

" 80 characters helps readability.
set textwidth=80

" Highlight the first three characters over the line length limit.  Clearing the
" highlight group first makes the background the same colour, so we only see
" this once we actually exceed the limit.
"
" (Note: we have to use autocommands for the highlighting since :colorscheme can
" overwrite this highlighting, and :colorscheme apparently gets applied after
" the .vimrc is done sourcing.)
set colorcolumn=+1,+2,+3
augroup color_tweak
  autocmd!
  autocmd ColorScheme * highlight clear ColorColumn
  autocmd ColorScheme * highlight ColorColumn guifg=red ctermfg=red gui=bold
augroup END

" Experience shows: tabs *occasionally* cause problems; spaces *never* do.
" Besides, vim is smart enough to make it "feel like" real tabs.
set tabstop=8 softtabstop=2 shiftwidth=2 expandtab smarttab
" Make tabs visible!
set list listchars=tab:»·,precedes:<,extends:>

" Unfortunately, visible tabs require 'list', which makes soft word wrap behave
" badly.  So it should be toggleable.
noremap <F8> :call List_toggle()<CR>
noremap! <F8> <Esc>:call List_toggle()<CR>a
" Telling the user whether "list mode" is on/off is not very informative.
" Instead, say exactly which feature they gained, and exactly which one they
" lost, by choosing this mode:
func! List_toggle()
  set list!
  let l:list_feat = "Showing Tabs"
  let l:nolist_feat = "Wrapping Words"
  echo (&list ? l:list_feat : l:nolist_feat)."! (but not ".
        \ (&list ? l:nolist_feat : l:list_feat).")"
endfunc

" Soft-wrapping is more readable than scrolling...
set wrap
" ...but don't break in the middle of a word!
set linebreak

" Almost every filetype is better with autoindent.
" (Let filetype-specific settings handle the rest.)
set autoindent

" Format options (full list at ":help fo-table"; see also ":help 'fo'")
" Change between += and -= to toggle an option
set formatoptions+=t  " Auto-wrap text...
set formatoptions+=c  " ...and comments.
set formatoptions+=q  " Let me format comments manually.
set formatoptions+=r  " Auto-continue comments if I'm still in insert mode,
set formatoptions-=o  " but not when coming from normal mode (that's annoying).
set formatoptions+=n  " Handle numbered lists properly: good for writing emails!
set formatoptions+=j  " Be smart about comment leaders when joining lines.

" Folding --------------------------------------------------------------{{{2
"
" Fold Focusing
" Close all folds, and open only enough to view the current line
nnoremap <Leader>z zMzv
" Go up (ZK) and down (ZJ) a fold, closing all other folds
nnoremap ZJ zjzMzv
nnoremap ZK zkzMzv

" Miscellaneous settings -----------------------------------------------{{{2

" When would I ever *not* want these?
set number   " Line numbers
set showcmd  " Show partial commands as you type

" Make backspace act like backspace in insert mode.
set backspace=indent,eol,start

" Occasionally useful, but mainly too annoying.
set nohlsearch
set completeopt-=preview

" Command line history: the default is just 20 lines!
set history=500

" Disable the bell
set vb t_vb=""

" Default colorscheme for terminal-mode vim is unreadable.
colorscheme desert

" I am much more often annoyed by swap files than helped by them.
set noswapfile

" Put a statusline for *every* window, *always*.
set laststatus=2

" This odd incantation disables scrollbars in gvim.  Source:
" http://thisblog.runsfreesoftware.com/?q=Remove+scrollbars+from+Gvim
set guioptions+=LlRrb
set guioptions-=LlRrb

" Always prefer vertical diffs (it's easier to understand when side-by-side).
" Note that newer versions of fugitive will sometimes use horizontal diffs
" (e.g., for thinner windows) unless this is explicitly set.
set diffopt+=vertical

" Persistent undo; see: https://advancedweb.hu/2017/09/19/vim-persistent-undo/
let s:undo_dir = '/tmp/.vim-undo-dir'
if (!isdirectory(s:undo_dir))
  call mkdir(s:undo_dir, 'p', 0700)
endif
execute 'set undodir=' . s:undo_dir
set undofile

" Plugin settings ---------------------------------------------------------{{{1

" ag -------------------------------------------------------------------{{{2

" Search for the word under the cursor, along with suitable prefix/suffix.
function! s:AgSearchWordUnderCursor(prefix, suffix)
  let l:word = escape(expand('<cword>'), '#')
  execute "Ag '" . a:prefix . l:word . a:suffix . "'"
endfunction

" :Ag the word under the cursor (populates quickfix list).
nnoremap <silent> <LocalLeader>ag :AgWordUnderCursor<CR>
command! -nargs=0 AgWordUnderCursor call s:AgSearchWordUnderCursor("\\b", "\\b")

" Hacky substitute for a proper "jump-to-definition".
"
" Look for `struct identifier`-type patterns, likewise for `class` and `using`.
" Typically, this gives me a very short list of candidates, even in a very large
" repo.  It's not uncommon for the right answer to be the only result!
nnoremap <silent> <LocalLeader>ad :AgHeuristicDefinitionWordUnderCursor<CR>
command! -nargs=0 AgHeuristicDefinitionWordUnderCursor 
        \ call s:AgSearchWordUnderCursor('(class|struct|using) ', "\\b(?!;)")

" airline --------------------------------------------------------------{{{2
" Use powerline symbols.
let g:airline_powerline_fonts = 1

" Show VTD late/due counts in statusline.
function! PrependVtdToAirline(...)
  call a:1.add_section('', '%#Error#%{vtd#statusline#Late()}%*')
  call a:1.add_section('', '%#Todo#%{vtd#statusline#Due()}%*')
  return 0
endfunction
call airline#add_statusline_func('PrependVtdToAirline')

" coc.nvim -------------------------------------------------------------{{{2

" Add a keyboard shortcut to populate location list with current diagnostics.
nnoremap <Leader>cd :CocDiagnostics<CR>:lclose<CR>

" Use tab for trigger completion with characters ahead and navigate.
" (This whole section is copy-pasted from coc's homepage.)
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Jump to definition/declaration.
nnoremap <silent> gd :call CocAction('jumpDefinition')<cr>
nnoremap <silent> gD :call CocAction('jumpDeclaration')<cr>
nnoremap <silent> gr :call CocAction('jumpReferences')<cr>
nnoremap <silent> gs :CocList symbols<cr>

" codefmt --------------------------------------------------------------{{{2
" Enable mappings.
Glaive codefmt plugin[mappings]

" dirvish --------------------------------------------------------------{{{2

let g:dirvish_mode = ':sort! | :sort! r /[/]$/'

" easytags -------------------------------------------------------------{{{2

" Make all tag files local to each project, rather than global.
set tags=./.tags;
let g:easytags_dynamic_files = 2

" fugitive -------------------------------------------------------------{{{2

nnoremap <silent> <LocalLeader>gs :Gstatus<CR>

" :Ggrep the word under the cursor (populates quickfix list).
nnoremap <silent> <LocalLeader>gg :GitGrepWordUnderCursor<CR>
command! -nargs=0 GitGrepWordUnderCursor call s:GitGrepWordUnderCursorImpl()
function! s:GitGrepWordUnderCursorImpl()
  let l:word = escape(expand('<cword>'), '#')
  execute "Ggrep '\\b" . l:word . "\\b'"
endfunction

" open-browser ---------------------------------------------------------{{{2
" netrw already uses this mapping; disable it.
let g:netrw_nogx = 1
nmap gx <Plug>(openbrowser-open)
vmap gx <Plug>(openbrowser-open)

" pandoc ---------------------------------------------------------------{{{2

" I find conceal harms my understanding of markdown documents.
let g:pandoc_use_conceal = 0

" This plugin egregiously enables all its modules by default, even the ones with
" surprising and unwelcome effects.  See:
" https://github.com/vim-pandoc/vim-pandoc/issues/272
let g:pandoc#modules#disabled = ["chdir"]

" syncopate ------------------------------------------------------------{{{2

" Enable keymapping for HTML output.
Glaive syncopate plugin[mappings]

" Don't copy the fold column (f), line numbers (n), or diff filler (d) in HTML
" output.
let g:html_prevent_copy = "fnd"
" But that only works for middle-click paste, and Ctrl-V is more useful for me.
" So just disable line numbers and folding altogether.
let g:html_number_lines = 0
let g:html_ignore_folding = 1

" UltiSnips ------------------------------------------------------------{{{2
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

" Experimental command to help me enter the flow state.
nnoremap ,foc :Focus<CR>a
command -nargs=0 Focus setfiletype markdown | normal! Ofocus

" unimpaired -----------------------------------------------------------{{{2

" Use the old `co` mappings instead of the new `yo` mappings.
"
" I use `coh` the most frequently, by far, and it's easier to type quickly and
" correctly than `yoh`.
"
" See: https://github.com/tpope/vim-unimpaired/issues/150
nmap co yo

" VTD ------------------------------------------------------------------{{{2

" Enable keymappings for VTD.
Glaive vtd plugin[mappings]

" Filetype settings (wrapped in an augroup for re-entrantness) ------------{{{1
" NOTE: I should probably consider putting these in a full-fledged ftplugin!

augroup vimrc_filetypes
  autocmd!
  " python ---------------------------------------------------------------{{{2
  autocmd BufWritePre *.py execute ':Black'

  " sh -------------------------------------------------------------------{{{2
  autocmd BufEnter /tmp/bash-fc-* setfiletype sh

  " physicsforums --------------------------------------------------------{{{2
  autocmd FileType physicsforums setlocal textwidth=0

  " Vim Quickfix ---------------------------------------------------------{{{2
  autocmd FileType qf setlocal textwidth=0 nowrap cursorline

  " gitcommit ------------------------------------------------------------{{{2
  autocmd FileType gitcommit setlocal textwidth=72

  " gitconfig ------------------------------------------------------------{{{2

  " `git config` uses hard tabs, but manually editing `~/.gitconfig` does not.
  "  This line corrects that inconsistency.
  autocmd FileType gitconfig setl noexpandtab shiftwidth=8 tabstop=8

  " TeX-type files -------------------------------------------------------{{{2

  " TeX + git: put each sentence on its own line(s) so the diffs are nicer.
  autocmd FileType tex,rnoweb setl textwidth=0

  " Vimscript ------------------------------------------------------------{{{2

  " Fold based on the triple-{ symbol.  sjl explains why you want this:
  " http://learnvimscriptthehardway.stevelosh.com/chapters/18.html
  autocmd FileType vim setlocal foldmethod=marker

" augroup END ----------------------------------------------------------{{{2
augroup END

" Nanoc helpers -----------------------------------------------------------{{{1

" The nanoc root at or above the given directory, or '' if none is found.
function! s:NanocRoot(path)
  let l:path_split = maktaba#path#Split(maktaba#path#GetDirectory(a:path))
  while len(l:path_split) > 0
    let l:dir = maktaba#path#Join(l:path_split)
    if maktaba#path#Exists(maktaba#path#Join([l:dir, 'nanoc.yaml']))
      return l:dir
    endif
    call remove(l:path_split, -1)
  endwhile
  return ''
endfunction

" Change to the nanoc root (if any), compile the website, and change back.
function! s:CompileNanoc()
  let l:cwd = getcwd()
  let l:nanoc_dir = s:NanocRoot(l:cwd)
  if empty(l:nanoc_dir)
    call maktaba#error#Warn('Nanoc not found under "' . l:cwd . '"!')
    return
  endif
  execute 'cd' l:nanoc_dir
  !nanoc
  execute 'cd' l:cwd
endfunction

command! -nargs=0 Nanoc call s:CompileNanoc()

" Local settings ----------------------------------------------------------{{{1

" We can put settings local to this particular machine in ~/.vimrc_local
if filereadable(expand("~/.vimrc_local"))
  source ~/.vimrc_local
endif

" Turn filetype back on ---------------------------------------------------{{{1
" This goes at the end for speed reasons.
filetype plugin indent on
syntax on

" Concealed characters are unreadable, so let's fix that.
highlight Conceal guibg=Black guifg=LightGrey
