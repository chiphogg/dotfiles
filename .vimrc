" Charles Hogg's vimrc settings

" Vundle -- the Right Way to manage Vim plugins ---------------------------{{{1

" The basic pattern of this code is adapted from gmarik/vundle README.md
" I believe this section has to come first... but looking back, I'm not
" really sure *why* I think that.

" Opening boilerplate --------------------------------------------------{{{2
set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle ---------------------------------------------{{{2
" required!
Bundle 'gmarik/vundle'
" ----------------------------------------------------------------------}}}2

" Vim enhancements
Bundle 'bufexplorer.zip'
Bundle 'bling/vim-airline'
Bundle 'SirVer/ultisnips'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-sleuth'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-vinegar'
Bundle 'tyru/open-browser.vim'

" Text objects (kana/vim-textobj-user is required by all the rest).
Bundle 'kana/vim-textobj-user'
Bundle 'glts/vim-textobj-comment'
Bundle 'Julian/vim-textobj-variable-segment'
Bundle 'kana/vim-textobj-entire'
Bundle 'kana/vim-textobj-indent'
Bundle 'sgur/vim-textobj-parameter'

" Git plugins
Bundle 'tpope/vim-fugitive'

" General Programming
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-endwise'
Bundle 'xolox/vim-easytags'
Bundle 'xolox/vim-misc'

" At work, or not:
if filereadable(expand('~/.at_google.vim'))
  " Google-only
  source ~/.at_google.vim
else
  " Non-Google only
  Bundle 'Valloric/YouCompleteMe'
  Bundle 'google/maktaba'
  Bundle 'google/glaive'
  call glaive#Install()
endif

" Python
Bundle 'klen/python-mode'

" R
Bundle 'jcfaria/Vim-R-plugin'

" Markdown and markup
Bundle 'tpope/vim-markdown'
Bundle 'vim-pandoc/vim-pandoc'

" My productivity system
Bundle 'chiphogg/vim-vtd'

filetype plugin indent on    " required for vundle (and generally a good idea!)

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
set fo -=t  " Don't auto-wrap text...
set fo +=c  " ...or comments; I believe this is causing epic E323/E316 errors
            " with easytag.vim (and possibly others).
set fo +=q  " Let me format comments manually.
set fo +=r  " Auto-continue comments if I'm still typing away in insert mode,
set fo -=o  "  but not if I'm coming from normal mode (I find this annoying).
set fo +=n  " Handle numbered lists properly: a lifesaver when writing emails!
set fo +=j  " Be smart about comment leaders when joining lines.

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
syntax on    " syntax highlighting
set showcmd  " Show partial commands as you type

" Occasionally useful, but mainly too annoying.
set nohlsearch

" Command line history: the default is just 20 lines!
set history=500

" Disable the bell
set vb t_vb=""

" Default colorscheme for terminal-mode vim is unreadable
colorscheme desert

" Don't litter directories with swap files; stick them all here.
set directory=~/.vimswp

" Put a statusline for *every* window, *always*.
set laststatus=2

" Plugin settings ---------------------------------------------------------{{{1

" airline --------------------------------------------------------------{{{2
" Use powerline symbols.
let g:airline_powerline_fonts = 1

" CtrlP ----------------------------------------------------------------{{{2

" Show hidden files.
let g:ctrlp_show_hidden = 1

let g:ctrlp_follow_symlinks = 1

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

" python-mode ----------------------------------------------------------{{{2
let g:pymode_folding = 1
let g:pymode_motion = 1

" I never use rope.
let g:pymode_rope = 0

" Syntastic ------------------------------------------------------------{{{2

" The location list is really convenient, and I always want to use it.
" (Don't forget that vim-unimpaired makes it even nicer!)
let g:syntastic_always_populate_loc_list = 1

" Not sure why I'd ever want my syntax checked when I'm quitting...
let g:syntastic_check_on_wq = 0

" UltiSnips ------------------------------------------------------------{{{2
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:UltiSnipsDontReverseSearchPath=1

" Vim-R Plugin ---------------------------------------------------------{{{2

" Don't expand _ into <-.
let vimrplugin_underscore = 0

" Don't line things up with opening braces.
let r_indent_align_args = 0

" Insert-mode mappings are incredibly annoying.
let g:vimrplugin_insert_mode_cmds = 0

" vimwiki --------------------------------------------------------------{{{2

" Open URLs with chrome, if possible
function! VimwikiLinkHandler(link)
  try
    if a:link =~# '\v^http'
      execute ':!google-chrome ' . a:link
      return 1
    endif
  catch
    echo "Couldn't open chrome.  Is the command 'google-chrome'?"
  endtry
  return 0
endfunction

" VTD ------------------------------------------------------------------{{{2

" Enable keymappings for VTD.
Glaive vtd plugin[mappings]

" YouCompleteMe --------------------------------------------------------{{{2

" Comments and strings are fair game for autocompletion.
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_comments_and_strings = 1

" Pop up a preview window with more info about the selected autocomplete option.
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 0
let g:ycm_autoclose_preview_window_after_insertion = 1

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

  " gitconfig ------------------------------------------------------------{{{2

  " `git config` uses hard tabs, but manually editing `~/.gitconfig` does not.
  "  This line corrects that inconsistency.
  autocmd FileType gitconfig setl noexpandtab shiftwidth=8 tabstop=8

  " Vimscript ------------------------------------------------------------{{{2

  " Fold based on the triple-{ symbol.  sjl explains why you want this:
  " http://learnvimscriptthehardway.stevelosh.com/chapters/18.html
  autocmd FileType vim setlocal foldmethod=marker

  " vimwiki --------------------------------------------------------------{{{2
  autocmd FileType vimwiki setlocal foldmethod=syntax

" augroup END ----------------------------------------------------------{{{2
augroup END

" Local settings ----------------------------------------------------------{{{1

" We can put settings local to this particular machine in ~/.vimrc_local
if filereadable(expand("~/.vimrc_local"))
  source ~/.vimrc_local
endif

