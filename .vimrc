""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FIRST: setup vundle, the vim package manager
" This code taken from https://github.com/gmarik/vundle/

set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" tpope's plugins (Tim Pope)
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-rhubarb'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-speeddating'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-markdown'

" tomtom's plugins (Tom Link)
Bundle 'chiphogg/viki_vim'
Bundle 'tomtom/tlib_vim'

" Fancy text objects
Bundle 'kana/vim-textobj-user'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'argtextobj.vim'

" Other plugins
Bundle 'suan/vim-instant-markdown'
Bundle 'jcf/vim-latex'
Bundle 'chiphogg/Vim-R-plugin'
Bundle 'spiiph/vim-space'
Bundle 'sjl/gundo.vim'
Bundle 'matchit.zip'
Bundle 'xolox/vim-easytags'

" Python stuff.  pydiction gives tab completion for python code. vim-flake8
" lets you check that formatting is PEP-8 compliant.
Bundle 'nvie/vim-flake8'
"Not working; not sure why...
"Bundle 'rkulla/pydiction'

"" Plugins to try later?
"Bundle 'Lokaltog/vim-powerline'
"Bundle 'Lokaltog/vim-easymotion'
"Bundle 'tomtom/tcomment_vim'
"Bundle 'gregsexton/gitv'
"Bundle 'EnhancedJumps'

filetype plugin indent on     " required!

" End vundle section
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

:set number
:let mapleader=","
:set ai
:set nohlsearch
:set tw=0
:set tabstop=2
:set sw=2
":map! <C-CR> </p><CR><CR><p>
":map! <S-CR> <br><CR>
:filetype plugin on
:filetype plugin indent on
:syntax on
:set wrap
:set linebreak
:set laststatus=2

" http://www.bulheller.com/vim/vimrc.shtml
" 2009-04-14
" Easy paste mode toggling
map <F7> :call Paste_on_off()<CR>
set pastetoggle=<F7>
let paste_mode = 0 " 0 = normal, 1 = paste
func! Paste_on_off()
    if g:paste_mode == 0
        set paste
        echo "Paste mode: ON"
        let g:paste_mode = 1
    else
        set nopaste
        echo "Paste mode: OFF"
        let g:paste_mode = 0
    endif
    return
endfunc

" Save, and quit with nonzero exit status
nnoremap ZE :w\|cq<CR>

" This prevents Ctrl-U and Ctrl-W from killing me :P
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>
inoremap <a-f> [<++>]

":source /usr/share/vim/vim72/macros/matchit.vim

:omap lp ?^$\\|^\s*\(\\begin\\|\\end\\|\\label\)?1<CR>//-1<CR>.<CR>

" LaTeX Suite stuff
:set winaltkeys=no
:let g:Tex_ItemStyle_sublist = '\item '
:let g:Tex_ItemStyle_outerlist = '\item[] '
:let g:Tex_ItemStyle_innerlist = '\item '
:let g:Tex_ItemStyle_subbulletlist = '\item '
:let g:tex_flavor = 'latex' 
:let g:Tex_CompileRule_dvi = 'latex -interaction=nonstopmode -src-specials $*'
:let g:Tex_GotoError=0
:let g:Tex_Env_subfigure = "\\subfloat[<+caption+>]\<CR>{\<CR>\\includegraphics[width=<+width+>]{<+eps file+>}\<CR>\\label{<+subfigure label+>}\<CR>}\<CR>\\hspace{<+spacing+>}<++>"
:let g:Tex_Env_subfloat = g:Tex_Env_subfigure
:let g:Tex_HotKeyMappings = 'itemize,enumerate'
:let g:Tex_PromptedCommands = 'footnote,texttt,textit,textbf'
:let g:Tex_Env_figure = "\\begin{figure}[<+Placement: (h)ere, separate (p)age, (t)op, (b)ottom+>]\<CR>\\begin{center}\<CR>\\includegraphics[width=<+width+>]{<+filename+>}\<CR>\\end{center}\<CR>\\caption{<+caption+>}\<CR>\\label{fig:<+label+>}\<CR>\\end{figure}<++>\<CR>"
:let g:Tex_Env_frame = "\\begin{frame}{<+Title+>}\<CR><+body+>\<CR>\\end{frame}<++>"
:let g:Tex_Env_columns = "\\begin{columns}[onlytextwidth]\<CR>\\begin{column}{0.5\\textwidth}\<CR>\\begin{center}\<CR><+ left +>\<CR>\\end{center}\<CR>\\end{column}\<CR>\\begin{column}{0.5\\textwidth}\<CR><+ right +>\<CR>\\end{column}\<CR>\\end{columns}"
:let g:Tex_Env_img = "\\includegraphics[width=<+width+>]{<+filename+>}"
:let g:leave_my_textwidth_alone = 1

" easy editing of this file
:nnoremap <Leader>ve :sp ~/.vimrc<CR>
:nnoremap <Leader>vs :source ~/.vimrc<CR>

" Datestamp <F4> and timestamp <F5>
nnoremap <F4> "=strftime("%F")<CR>p
vnoremap <F4> "=strftime("%F")<CR>p
inoremap <F4> <C-R>=(strftime("%F"))<CR>
cnoremap <F4> <C-R>=(strftime("%F"))<CR>
nnoremap <F5> "=strftime("%R")<CR>p
vnoremap <F5> "=strftime("%R")<CR>p
inoremap <F5> <C-R>=(strftime("%R"))<CR>
cnoremap <F5> <C-R>=(strftime("%R"))<CR>

" vim viki stuff
au BufRead,BufNewFile *.viki set ft=viki
let g:vikiHide="update"
let g:vikiUseParentSuffix = 1
let g:vikiNameTypes="sSeuixwf"
let g:vikiOpenUrlWith_http = '!firefox %{URL}'
let g:vikiOpenUrlWith_https = '!firefox %{URL}'
let g:vikiFolds="hf"
let b:vikiNoSimpleNames=1

" Taken from ":help [["
" Modified 2011-02-04 using http://vim.wikia.com/wiki/Search_for_visually_selected_text
" Goal being to leave search buffers untouched
function! JumpToFuncBound(times, searchstr, breakoutstr)
  let old_reg=getreg('/')
  let old_regtype=getregtype('/')
  norm m'
  for i in range(a:times)
    exe a:searchstr
    norm a:breakoutstr
  endfor
  call setreg('/', old_reg, old_regtype)
endf
map [[ :<C-U>call JumpToFuncBound(v:count1, "?{", "w999[{")<CR><C-L>
map ][ :<C-U>call JumpToFuncBound(v:count1, "/}", "w999]}")<CR><C-L>
map ]] :<C-U>norm 0f{999]}][%<CR>
map [] :let old_reg=getreg('/')<Bar>let old_regtype=getregtype('/')<CR>k$][%?}<CR>:call setreg('/', old_reg, old_regtype)<CR>

map [[ ?{<CR>w99[{
map ][ /}<CR>b99]}
map ]] j0[[%/{<CR>
map [] k$][%?}<CR>

let vimrplugin_term_cmd = "urxvt -e R --vanilla"

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
" asterisk, left contraction, right contraction
digraph as 8727
digraph lc 8971
digraph rc 8970

" Disable the bell
set vb t_vb=""

" Really, you always want the backtick, but the apostrophe is much more
" conveniently located.  So, swap 'em!
nnoremap ' `
nnoremap ` '

" Read in any settings which are local to this computer 
" (i.e. NOT synchronized via unison)
let s:localSettings = glob('~/.localvimrc')
if len(s:localSettings) > 0
 source ~/.localvimrc
endif

" Code I wrote 2011-09-30 to maximize windows easily
function! MaximizeWindow()
  exe "norm \<C-W>99999>\<C-W>_"
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
" Make tab navigation easier
nnoremap <silent> <Leader>tn :tabnew<CR>:tabmove<CR>
nnoremap <silent> <Leader>th :tabprevious<CR>
nnoremap <silent> <Leader>tl :tabnext<CR>

" Code from 2011-09-30 to put current filename in paste buffer
function! CopyBuffer(fromBuffer, toBuffer)
  let old_reg=getreg(a:fromBuffer)
  let old_regtype=getregtype(a:fromBuffer)
  call setreg(a:toBuffer, old_reg, old_regtype)
endf
nnoremap <silent> <Leader>% :call CopyBuffer('%', '"')<CR>

" PRODUCTIVITY SYSTEM stuff
" Refresh today's tasks
nnoremap <silent> <Leader>tt :!TaskTodayViki<CR><CR>zMzv
" Edit current contexts
nnoremap <Leader>tcc :echo "This should edit your 'CURRENT task-context' file... but you haven't yet figured out how exactly you want that to work!"<CR>
nnoremap <Leader>tcl :sp ~/productivity/viki/.localContexts<CR>

" Fold focusing: 
" close all folds, and open only enough to view the current line
nnoremap <Leader>z zMzv
nnoremap ZJ zjzMzv
nnoremap ZK zkzMzv

" 2011-10-05: converted to spacifying my tabs.  First, make any tab characters
" visible; then, turn off this setting for all files.
set list listchars=tab:»·,precedes:<,extends:>
set expandtab
" Also highlight trailing whitespace (but not in insert mode)
" See http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
" Finally, setting 'list' makes word wrap behave badly.  So it should be
" toggleable.
map <F8> :call List_on_off()<CR>
map! <F8> <Esc>:call List_on_off()<CR>a
let g:list_mode = 1 " 0 = normal, 1 = list
func! List_on_off()
    if g:list_mode == 0
        set list
        echo "List mode: ON"
        let g:list_mode = 1
    else
        set nolist
        echo "List mode: OFF"
        let g:list_mode = 0
    endif
    return
endfunc

" Change the local current directory to the directory of the file being
" edited: http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
" 2011-12-13
autocmd BufEnter * silent! lcd %:p:h

" Make all tag files local to each project, rather than global.
:set tags=./.tags;
:let g:easytags_dynamic_files = 2
