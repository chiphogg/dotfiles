" Charles Hogg's vimrc settings

" Vundle -- the Right Way to manage Vim plugins ---------------------------{{{1

" The basic pattern of this code is adapted from gmarik/vundle README.md

" Opening boilerplate --------------------------------------------------{{{2
set nocompatible

" It's faster to turn off 'filetype' while loading plugins, and turn it on only
" once we're ready to start editing.
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" let Vundle manage Vundle ---------------------------------------------{{{2
" required!
Plugin 'gmarik/vundle'
" ----------------------------------------------------------------------}}}2

" Vim enhancements
Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'bufexplorer.zip'
Plugin 'ConradIrwin/vim-bracketed-paste'
Plugin 'eiginn/netrw'
Plugin 'google/vim-syncopate'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-scriptease'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-speeddating'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-vinegar'
Plugin 'tyru/open-browser.vim'

" Snippets.
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

" Text objects (kana/vim-textobj-user is required by all the rest).
Plugin 'kana/vim-textobj-user'
Plugin 'glts/vim-textobj-comment'
Plugin 'Julian/vim-textobj-variable-segment'
Plugin 'kana/vim-textobj-entire'
Plugin 'kana/vim-textobj-indent'
Plugin 'sgur/vim-textobj-parameter'

" Git plugins
Plugin 'tpope/vim-fugitive'

" General Programming
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-endwise'
Plugin 'xolox/vim-easytags'
Plugin 'xolox/vim-misc'

" At work, or not:
if filereadable(expand('~/.at_google.vim'))
  " Google-only
  source ~/.at_google.vim
else
  " Non-Google only
  Plugin 'Valloric/YouCompleteMe'
  Plugin 'google/maktaba'
  Plugin 'google/glaive'
endif

" Python
Plugin 'klen/python-mode'

" Markdown and markup
Plugin 'tpope/vim-markdown'
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax'

" My productivity system
Plugin 'chiphogg/vim-vtd'

call vundle#end()
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

" Highlight trailing whitespace (but not in insert mode).
" See http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
augroup extra_whitespace
  autocmd!
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd BufWinLeave * call clearmatches()
augroup END

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

" Occasionally useful, but mainly too annoying.
set nohlsearch
set completeopt-=preview

" Command line history: the default is just 20 lines!
set history=500

" Disable the bell
set vb t_vb=""

" Default colorscheme for terminal-mode vim is unreadable.
colorscheme desert
" Concealed characters in desert are *also* unreadable, so let's fix that.
highlight Conceal guibg=Black

" Don't litter directories with swap files; stick them all here.
set directory=~/.vimswp

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

" Plugin settings ---------------------------------------------------------{{{1

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

" netrw ----------------------------------------------------------------{{{2

" <Ctrl-^> should never go to netrw; we'd just use `-` (from vinegar) to do
" that.  Make it go to the previous actual file instead.
let g:netrw_altfile = 1

" open-browser ---------------------------------------------------------{{{2
" netrw already uses this mapping; disable it.
let g:netrw_nogx = 1
nmap gx <Plug>(openbrowser-open)
vmap gx <Plug>(openbrowser-open)

" pandoc ---------------------------------------------------------------{{{2

" I find conceal harms my understanding of markdown documents.
let g:pandoc_use_conceal = 0

" python-mode ----------------------------------------------------------{{{2
let g:pymode_folding = 1
let g:pymode_motion = 1

" I never use rope.
let g:pymode_rope = 0

" Use syntastic to lint python instead.
let g:pymode_lint = 0

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

" Syntastic ------------------------------------------------------------{{{2

" The location list is really convenient, and I always want to use it.
" (Don't forget that vim-unimpaired makes it even nicer!)
let g:syntastic_always_populate_loc_list = 1

" Not sure why I'd ever want my syntax checked when I'm quitting...
let g:syntastic_check_on_wq = 0

" Filetype-specific settings.
let g:syntastic_javascript_checkers = ['gjslint']
let g:syntastic_javascript_gjslint_args = '--strict'

" UltiSnips ------------------------------------------------------------{{{2
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

" Experimental command to help me enter the flow state.
nnoremap ,foc :Focus<CR>a
command -nargs=0 Focus setfiletype markdown | normal! Ofocus

" VTD ------------------------------------------------------------------{{{2

" Enable keymappings for VTD.
Glaive vtd plugin[mappings]

" Vundle ---------------------------------------------------------------{{{2

" Keyboard shortcut to update vundle plugins.
nnoremap <Leader>vu :VundleUpdate<CR>

" YouCompleteMe --------------------------------------------------------{{{2

" Turn it on for everything; it's annoying not to have it.
let g:ycm_filetype_blacklist = {}

" Comments and strings are fair game for autocompletion.
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_comments_and_strings = 1

" Skip the preview window.
let g:ycm_add_preview_to_completeopt = 0

" Start autocompleting right away, after a single character!
let g:ycm_min_num_of_chars_for_completion = 1

" This gives me nice autocompletion for C++ #include's if I change vim's working
" directory to the project root.
let g:ycm_filepath_completion_use_working_dir = 1

" Add programming language keywords to the autocomplete list.
let g:ycm_seed_identifiers_with_syntax = 1

" The signs are nice, but they're way too slow for me.
let g:ycm_enable_diagnostic_signs = 0

" This can change the location list out from under me.  Instead, populate it
" manually using :YcmDiags.
let g:ycm_always_populate_location_list = 0
let g:ycm_open_loclist_on_ycm_diags = 0

" g[ should jump to the declaration (currently only works in C-family files).
nnoremap <silent> g[ :YcmCompleter GoToDeclaration<CR>
" Force a *synchronous* compile-and-check.
" (Caution!  Blocking, and potentially slow.)
nnoremap <silent> <Leader>c :YcmForceCompileAndDiagnostics<CR>
" Try this before restarting vim (useful if the cache gets stale).
nnoremap <silent> <Leader>C :YcmCompleter ClearCompilationFlagCache<CR>
" Repopulate the location list.
nnoremap <silent> <Leader>l :YcmDiags<CR>

" Filetype settings (wrapped in an augroup for re-entrantness) ------------{{{1
" NOTE: I should probably consider putting these in a full-fledged ftplugin!

augroup vimrc_filetypes
  autocmd!

  " physicsforums --------------------------------------------------------{{{2
  autocmd FileType physicsforums setlocal textwidth=0

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

" Local settings ----------------------------------------------------------{{{1

" We can put settings local to this particular machine in ~/.vimrc_local
if filereadable(expand("~/.vimrc_local"))
  source ~/.vimrc_local
endif

" Turn filetype back on ---------------------------------------------------{{{1
" This goes at the end for speed reasons.
filetype plugin indent on
syntax on
