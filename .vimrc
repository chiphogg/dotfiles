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

" tpope's plugins (Tim Pope)
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-haml'

" tomtom's plugins (Tom Link)
Bundle 'tomtom/viki_vim'
Bundle 'tomtom/tlib_vim'

" Fancy text objects
Bundle 'kana/vim-textobj-user'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'argtextobj.vim'

" Other plugins
Bundle 'vim-pandoc/vim-pandoc'
Bundle 'tpope/vim-markdown'
Bundle 'jcf/vim-latex'
Bundle 'jcfaria/Vim-R-plugin'
Bundle 'sjl/gundo.vim'
Bundle 'matchit.zip'
Bundle 'xolox/vim-easytags'
Bundle 'chiphogg/vim-choggutils'
Bundle 'godlygeek/tabular'
Bundle 'chiphogg/vim-vtd'
Bundle 'vimwiki'
Bundle 'duff/vim-scratch'
Bundle 'wincent/Command-T'
Bundle 'bufexplorer.zip'
Bundle 'scrooloose/nerdtree'
Bundle 'chiphogg/vim-foldypython'
Bundle 'VOoM'

" Python stuff.  pydiction gives tab completion for python code. vim-flake8
" lets you check that formatting is PEP-8 compliant.
Bundle 'nvie/vim-flake8'
"Not working; not sure why...
"Bundle 'rkulla/pydiction'

"" Plugins to try later?
"Bundle 'Lokaltog/vim-easymotion'
"Bundle 'tomtom/tcomment_vim'
"Bundle 'gregsexton/gitv'
"Bundle 'EnhancedJumps'
"" https://github.com/garbas/vim-snipmate/

" Confused?  Read ":help :filetype-overview"
filetype plugin indent on    " required for vundle! (and generally a good idea)

" Basic settings ----------------------------------------------------------{{{1

" ',' is easy to type, so use it for <Leader> to make compound commands easier:
let mapleader=","
" Unfortunately, this introduces a delay for the ',' command.  Let's compensate
" by introducing a speedy alternative...
noremap ,. ,

" Customized statusline =) ---------------------------------------------{{{2
" First, setup fugitive statusline to be used if fugitive is installed.
" Adapted from http://stackoverflow.com/q/5983906/1523582
"
" FIXME: Note that this gives me a git statusline even for non-git files!
" There must be a better way...
func! GitStat()
  let l:gstat=''
  runtime! autoload/fugitive.vim
  if exists('*fugitive#statusline')
    let l:gstat=fugitive#statusline()
  endif
  return l:gstat
endfunc
" Put a statusline for *every* window, *always*.
set laststatus=2
" Now, set what actually goes in that statusline:
set statusline =%-.20F\         " Full pathname, left-justified
set statusline+=%h              " 'Help' flag
set statusline+=%m              " 'Modified' flag
set statusline+=%r\ \ \         " 'Readonly' flag
set statusline+=%{GitStat()}    " Git statusline from fugitive.vim
set statusline+=%=              " Everything else goes to the far-right
set statusline+=%-14.(%l,%c%V%) " Current line
set statusline+=\ (%P)          " Percentage through the file

" Diff mode ------------------------------------------------------------{{{2

if &diff
  noremap <Leader>1 :diffget LOCAL<CR>
  noremap <Leader>2 :diffget BASE<CR>
  noremap <Leader>3 :diffget REMOTE<CR>
endif

" Folding --------------------------------------------------------------{{{2
"
" Fold Focusing
" Close all folds, and open only enough to view the current line
nnoremap <Leader>z zMzv
" Go up (ZK) and down (ZJ) a fold, closing all other folds
nnoremap ZJ zjzMzv
nnoremap ZK zkzMzv

" Start with the "big-picture" view of a file
set foldlevelstart=0

" Windows, tabs, and buffers -------------------------------------------{{{2

" Finally getting comfortable enough with buffers to use this:
set hidden

" Code I wrote 2011-09-30 to maximize windows easily
function! MaximizeWindow()
  exe "normal! \<C-W>99999>\<C-W>_"
endf
nnoremap <silent> <Leader>m        :call MaximizeWindow()<CR>
nnoremap <silent> <Leader>wm       :call MaximizeWindow()<CR>
" Move-and-maximize
nnoremap <silent> <Leader>wH <C-W>h:call MaximizeWindow()<CR>
nnoremap <silent> <Leader>wJ <C-W>j:call MaximizeWindow()<CR>
nnoremap <silent> <Leader>wK <C-W>k:call MaximizeWindow()<CR>
nnoremap <silent> <Leader>wL <C-W>l:call MaximizeWindow()<CR>
nnoremap <silent> <Leader>ww <C-W>w:call MaximizeWindow()<CR>
nnoremap <silent> <Leader>wW <C-W>W:call MaximizeWindow()<CR>
" Move-and-half-maximize
nnoremap <silent> <Leader>wh <C-W>h<C-W>99999>
nnoremap <silent> <Leader>wj <C-W>j<C-W>_
nnoremap <silent> <Leader>wk <C-W>k<C-W>_
nnoremap <silent> <Leader>wl <C-W>l<C-W>99999>
" Quick access to commands
nnoremap <Leader>wc <C-W>c
" Commands to put a definition in a previous (one-liner) window (d), and to
" kill that window (with (x) or without (X) maximizing the current window)
nnoremap          <Leader>wd <C-W><Tab>z<CR>1<C-W>_<C-W>w
nnoremap          <Leader>wx <C-W>W<C-W>c
nnoremap <silent> <Leader>wX <C-W>W<C-W>c:call MaximizeWindow()<CR>
" Kill all other windows (also turns off diff mode)
nnoremap <silent> <Leader>wo :diffoff<CR><C-W>o

" Text formatting ------------------------------------------------------{{{2

" 80 characters helps readability (79 for fudge factor).
set textwidth=79

" Spaces or tabs?
" Experience shows: tabs *occasionally* cause problems; spaces *never* do.
" e.g., http://bugs.python.org/issue7012
" Besides, vim is smart enough to make it "feel like" real tabs.
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab
" Make tabs visible!
set list listchars=tab:»·,precedes:<,extends:>
" Also highlight trailing whitespace (but not in insert mode)
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

" Improving basic commands ---------------------------------------------{{{2

" Easy quit-all, which is unlikely to be mistyped.
nnoremap <silent> <Leader>qwer :confirm qa<CR>

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

"" Taken from ":help section"
"" Modified 2011-02-04 using http://vim.wikia.com/wiki/Search_for_visually_selected_text
"" (Goal being to leave search buffers untouched)
"" Unfortunately, this just doesn't work right now, so I'm commenting it out.
"function! JumpToFuncBound(times, searchstr, breakoutstr)
"  let old_reg=getreg('/')
"  let old_regtype=getregtype('/')
"  norm m'
"  for i in range(a:times)
"    exe a:searchstr
"    norm a:breakoutstr
"  endfor
"  call setreg('/', old_reg, old_regtype)
"endf
"noremap [[ :<C-U>call JumpToFuncBound(v:count1, "?{", "w999[{")<CR><C-L>
"noremap ][ :<C-U>call JumpToFuncBound(v:count1, "/}", "w999]}")<CR><C-L>
"noremap ]] :<C-U>norm 0f{999]}][%<CR>
"noremap [] :let old_reg=getreg('/')<Bar>let old_regtype=getregtype('/')<CR>k$][%?}<CR>:call setreg('/', old_reg, old_regtype)<CR>

" So, I basically just use the provided versions.  They pollute history... 
" but they work!
noremap [[ ?{<CR>w99[{
noremap ][ /}<CR>b99]}
noremap ]] j0[[%/{<CR>
noremap [] k$][%?}<CR>

" Small feature enhancements -------------------------------------------{{{2

" Easy editing of .vimrc: ,ve to edit; ,vs to source ----------------{{{3
nnoremap <Leader>ve :split ~/.vimrc<CR>
nnoremap <Leader>vs :source ~/.vimrc<CR>

" Easy Datestamp <F4> and timestamp <F5> ----------------------------{{{3
nnoremap <F4> "=strftime("%F")<CR>p
vnoremap <F4> "=strftime("%F")<CR>p
inoremap <F4> <C-R>=(strftime("%F"))<CR>
cnoremap <F4> <C-R>=(strftime("%F"))<CR>
nnoremap <F5> "=strftime("%R")<CR>p
vnoremap <F5> "=strftime("%R")<CR>p
inoremap <F5> <C-R>=(strftime("%R"))<CR>
cnoremap <F5> <C-R>=(strftime("%R"))<CR>

" Easy paste mode toggling with <F7> --------------------------------{{{3
" adapted and simplified from http://www.bulheller.com/vimrc.html

" Normal mode:
nnoremap <silent> <F7> :call Paste_toggle()<CR>
func! Paste_toggle()
  set paste!
  echo "Paste mode: ".(&paste ? "ON" : "OFF")
endfunc
" Insert mode:
set pastetoggle=<F7>

" Refresh syntax highlighting <F12> ---------------------------------{{{3
" Very handy when constructing a syntax file!
nnoremap <silent> <F12> :syntax clear \| syntax off \| syntax on<CR>

" Digraphs (easy input for certain non-ASCII chars) --------------------{{{2

" Script-l, latex 'ell', is handy to have.  Need to convert hex (2113) to
" decimal (8467).
digraph el 8467
" Similarly, ballot check and 'x'
digraph ck 10003
digraph cx 10007
" Parallel, perpendicular, dagger
digraph pa 8741
digraph pe 10178
digraph da 8224
" "nabla" character
digraph nb 8711

" Useful for geometric algebra:
" asterisk, left contraction, right contraction
digraph as 8727
digraph lc 8971
digraph rc 8970

" Miscellaneous settings -----------------------------------------------{{{2

" When would I ever *not* want these?
set number   " Line numbers
syntax on    " syntax highlighting
set showcmd  " Show partial commands as you type

" Occasionally useful, but mainly too annoying.
set nohlsearch

" Disable the bell
set vb t_vb=""

" Plugin settings ---------------------------------------------------------{{{1

" fugitive -------------------------------------------------------------{{{2

nnoremap <silent> <LocalLeader>gs :Gstatus<CR>

" Command-T ------------------------------------------------------------{{{2

" Defaults conflict with my VTD plugin and bufexplorer, so I remap 'em:
nnoremap <silent> <LocalLeader>t :CommandT<CR>
nnoremap <silent> <LocalLeader>b :CommandTBuffer<CR>

" easytags -------------------------------------------------------------{{{2

" Make all tag files local to each project, rather than global.
set tags=./.tags;
let g:easytags_dynamic_files = 2

" LaTeX Suite ----------------------------------------------------------{{{2
set winaltkeys=no
onoremap lp ?^$\\|^\s*\(\\begin\\|\\end\\|\\label\)?1<CR>//-1<CR>.<CR>
let g:Tex_ItemStyle_sublist = '\item '
let g:Tex_ItemStyle_outerlist = '\item[] '
let g:Tex_ItemStyle_innerlist = '\item '
let g:Tex_ItemStyle_subbulletlist = '\item '
let g:tex_flavor = 'latex' 
let g:Tex_CompileRule_dvi = 'latex -interaction=nonstopmode -src-specials $*'
let g:Tex_GotoError=0
let g:Tex_Env_subfigure = "\\subfloat[<+caption+>]\<CR>{\<CR>\\includegraphics[width=<+width+>]{<+eps file+>}\<CR>\\label{<+subfigure label+>}\<CR>}\<CR>\\hspace{<+spacing+>}<++>"
let g:Tex_Env_subfloat = g:Tex_Env_subfigure
let g:Tex_HotKeyMappings = 'itemize,enumerate'
let g:Tex_PromptedCommands = 'footnote,texttt,textit,textbf'
let g:Tex_Env_figure = "\\begin{figure}[<+Placement: (h)ere, separate (p)age, (t)op, (b)ottom+>]\<CR>\\begin{center}\<CR>\\includegraphics[width=<+width+>]{<+filename+>}\<CR>\\end{center}\<CR>\\caption{<+caption+>}\<CR>\\label{fig:<+label+>}\<CR>\\end{figure}<++>\<CR>"
let g:Tex_Env_frame = "\\begin{frame}{<+Title+>}\<CR><+body+>\<CR>\\end{frame}<++>"
let g:Tex_Env_columns = "\\begin{columns}[onlytextwidth]\<CR>\\begin{column}{0.5\\textwidth}\<CR>\\begin{center}\<CR><+ left +>\<CR>\\end{center}\<CR>\\end{column}\<CR>\\begin{column}{0.5\\textwidth}\<CR><+ right +>\<CR>\\end{column}\<CR>\\end{columns}"
let g:Tex_Env_img = "\\includegraphics[width=<+width+>]{<+filename+>}"
let g:leave_my_textwidth_alone = 1

" NERD-tree ------------------------------------------------------------{{{2
nnoremap <Leader>/ :NERDTreeToggle<CR>

" viki -----------------------------------------------------------------{{{2

augroup filetype_viki
  autocmd!
  " Change the local current directory to the directory of the file being
  " edited: http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
  " (This gives me C-X,C-F filename autocompletion)
  autocmd BufEnter *.viki silent! lcd %:p:h
  " Smoother (vimwiki-style) navigation:
  autocmd FileType viki
        \ exec "nnoremap <buffer> <silent> <Tab> :VikiFindNext<CR>"
  autocmd FileType viki
        \ exec "nnoremap <buffer> <silent> <S-Tab> :VikiFindPrev<CR>"
  autocmd FileType viki exec "nnoremap <buffer> <silent> <CR> :VikiJump<CR>"
  autocmd FileType viki let b:vikiNoSimpleNames=1
augroup END

let g:vikiHide="update"
let g:vikiUseParentSuffix = 1
let g:vikiNameTypes="sSeuixwf"
let g:vikiOpenUrlWith_http = '!firefox %{URL}'
let g:vikiOpenUrlWith_https = '!firefox %{URL}'
let g:vikiFolds="hf"
let g:vikiFoldMethodVersion=1

" Vim-R Plugin ---------------------------------------------------------{{{2

let r_indent_align_args = 0
let vimrplugin_term_cmd = "urxvt -e R --vanilla"
let vimrplugin_underscore = 0

" Disable insert-mode commands (incredibly annoying when writing R
" documentation, or Sweave):
:let g:vimrplugin_insert_mode_cmds = 0
" Not sure yet if I want to install screen
:let g:vimrplugin_screenplugin = 0


" vimwiki --------------------------------------------------------------{{{2

" Enable folding; it's really handy :)
let g:vimwiki_folding=1

" I already use ',ww' for zooming around windows, so I need to remap it:
nmap <Leader><Leader>ww <Plug>VimwikiIndex

" VOoM -----------------------------------------------------------------{{{2
let g:voom_ft_modes = {}
let g:voom_ft_modes['viki'] = 'viki'
let g:voom_ft_modes['vimwiki'] = 'vimwiki'
let g:voom_ft_modes['markdown'] = 'markdown'
let g:voom_ft_modes['pandoc'] = 'markdown'
nnoremap <Leader>o :<C-U>VoomToggle<CR>

" VTD ------------------------------------------------------------------{{{2

" I like my VTD commands to start with ',t'
" (',th' to go Home, ',td' to check off as "done", etc.)
let g:vtd_map_prefix=',t'

" Filetype settings -------------------------------------------------------{{{1
" NOTE: I should probably consider putting these in a full-fledged ftplugin!

" Python ---------------------------------------------------------------{{{2
augroup filetype_python
  autocmd!
  " Helping vim with python's PEP-8 conventions; taken from:
  " http://henry.precheur.org/vim/python
  autocmd FileType python setlocal
        \ shiftwidth=4
        \ softtabstop=4
        \ tabstop=4
        \ textwidth=80
        \ smarttab
        \ expandtab
augroup END

" Vimscript ------------------------------------------------------------{{{2
augroup filetype_vim
  autocmd!
  " Fold based on the triple-{ symbol.  sjl explains why you want this:
  " http://learnvimscriptthehardway.stevelosh.com/chapters/18.html
  autocmd FileType vim setlocal foldmethod=marker
augroup END

" voomtree -------------------------------------------------------------{{{2

augroup filetype_voomtree
  autocmd!
  " Let hjkl navigate the tree just like arrow keys.  It's the Vim way. :)
  autocmd FileType voomtree nnoremap <buffer><silent> j j:<C-u>call Voom_TreeSelect(1)<CR>
  autocmd FileType voomtree nnoremap <buffer><silent> k k:<C-u>call Voom_TreeSelect(1)<CR>
  autocmd FileType voomtree nnoremap <buffer><silent> h :<C-u>call Voom_TreeLeft()<CR>
  autocmd FileType voomtree nnoremap <buffer><silent> l :<C-u>call Voom_TreeRight()<CR>
augroup END

" Local settings ----------------------------------------------------------{{{1

" We can put settings local to this particular machine in ~/.vimrc_local
if filereadable(expand("~/.vimrc_local"))
  source ~/.vimrc_local
endif

