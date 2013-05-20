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
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Bundle 'scrooloose/nerdtree'
Bundle 'SirVer/ultisnips'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'

" Git plugins
Bundle 'airblade/vim-gitgutter'
Bundle 'tpope/vim-fugitive'

" General Programming
Bundle 'scrooloose/syntastic'
Bundle 'Valloric/YouCompleteMe'
Bundle 'xolox/vim-easytags'

" R Programming
Bundle 'jcfaria/Vim-R-plugin'

" Markdown and markup
Bundle 'tpope/vim-markdown'
Bundle 'vim-pandoc/vim-pandoc'

" My productivity system
Bundle 'chiphogg/vim-vtd'
Bundle 'vimwiki'

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

" Highlight lines which are too long
set colorcolumn=+1

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

" fugitive -------------------------------------------------------------{{{2

nnoremap <silent> <LocalLeader>gs :Gstatus<CR>

" easytags -------------------------------------------------------------{{{2

" Make all tag files local to each project, rather than global.
set tags=./.tags;
let g:easytags_dynamic_files = 2

" NERD-tree ------------------------------------------------------------{{{2
nnoremap <Leader>/ :NERDTreeToggle<CR>

" CtrlP ----------------------------------------------------------------{{{2

" Show hidden files.
let g:ctrlp_show_hidden = 1

let g:ctrlp_follow_symlinks = 1

" Vim-R Plugin ---------------------------------------------------------{{{2

" Don't expand _ into <-.
let vimrplugin_underscore = 0

" Don't line things up with opening braces.
let r_indent_align_args = 0

" UltiSnips ------------------------------------------------------------{{{2
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
let g:UltiSnipsDontReverseSearchPath=1

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

" I like my VTD commands to start with ',t'
" (',th' to go Home, ',td' to check off as "done", etc.)
let g:vtd_map_prefix=',t'

" YouCompleteMe --------------------------------------------------------{{{2

" Comments and strings are fair game for autocompletion.
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_comments_and_strings = 1

" Pop up a preview window with more info about the selected autocomplete option.
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 0

" Start autocompleting right away, after a single character!
let g:ycm_min_num_of_chars_for_completion = 1

" g[ should jump to the declaration (currently only works in C-family files).
nnoremap g[ :YcmCompleter GoToDeclaration<CR>

" This gives me nice autocompletion for C++ #include's if I change vim's working
" directory to the project root.
let g:ycm_filepath_completion_use_working_dir = 1

" Filetype settings -------------------------------------------------------{{{1
" NOTE: I should probably consider putting these in a full-fledged ftplugin!

" Vimscript ------------------------------------------------------------{{{2
augroup filetype_vim
  autocmd!
  " Fold based on the triple-{ symbol.  sjl explains why you want this:
  " http://learnvimscriptthehardway.stevelosh.com/chapters/18.html
  autocmd FileType vim setlocal foldmethod=marker
augroup END

" vimwiki --------------------------------------------------------------{{{2
augroup filetype_vimwiki
  autocmd!
  autocmd FileType vimwiki setlocal foldmethod=syntax
augroup END

" Local settings ----------------------------------------------------------{{{1

" We can put settings local to this particular machine in ~/.vimrc_local
if filereadable(expand("~/.vimrc_local"))
  source ~/.vimrc_local
endif

