"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" by Amix - http://amix.dk/
"
" Maintainer: redguardtoo <chb_sh@hotmail.com>, Amir Salihefendic <amix3k at gmail.com>
" Version: 2.1
" Last Change: 21/03/08 23:00:01
" fix some performance issue and syntax bugs
" Last Change: 12/08/06 13:39:28
" Fixed (win32 compatible) by: redguardtoo <chb_sh at gmail.com>
" This vimrc file is tested on platforms like win32,linux, cygwin,mingw
" and vim7.0, vim6.4, vim6.1, vim5.8.9 by redguardtoo
"
"
" Tip:
" If you find anything that you can't understand than do this:
" help keyword OR helpgrep keyword
" Example:
" Go into command-line mode and type helpgrep nocompatible, ie.
" :helpgrep nocompatible
" then press <leader>c to see the results, or :botright cw
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" turn off nice effect on status bar title
let performance_mode=0
let use_plugins_i_donot_use=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Get out of VI's compatible mode..

set nocompatible

set encoding=utf-8
set termencoding=chinese
set langmenu=zh_CN.UTF-8
language messages zh_CN.UTF-8

function! MySys()
    if has("win32")
        return "win32"
    elseif has("unix")
        return "unix"
    else
        return "mac"
    endif
endfunction
"Set shell to be bash
if MySys() == "unix" || MySys() == "mac"
    set shell=bash
else
    "I have to run win32 python without cygwin
    "set shell=E:cygwininsh
endif

"Sets how many lines of history VIM har to remember
set history=400

"Enable filetype plugin
filetype on
if has("eval") && v:version>=600
    filetype plugin on
    filetype indent on
endif

"Set to auto read when a file is changed from the outside
if exists("&autoread")
    "set autoread
endif

"Have the mouse enabled all the time:
"The mouse can be enabled for different modes:
"n Normal mode
"v Visual mode
"i Insert mode
"c Command-line mode
"h all previous modes when editing a help file
"a all previous modes
"r for |hit-enter| and |more-prompt| prompt
if exists("&mouse")
    set mouse=a
endif

"Set mapleader
let mapleader = ","
let g:mapleader = ","

"Fast saving
"nmap <leader>x :xa!<cr>
nmap <leader>w :w!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Font
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable syntax hl
if MySys()=="unix"
    if v:version<600
        if filereadable(expand("$VIM/syntax/syntax.vim"))
            syntax on
        endif
    else
        syntax on
    endif
else
    syntax on
endif

"internationalization
"I only work in Win2k Chinese version
if has("multi_byte")
    "set bomb
  set fileencodings=ucs-bom,utf-8,cp936,big5,latin1
  " CJK environment detection and corresponding setting
  if v:lang =~ "^zh_CN"
    " Use cp936 to support GBK, euc-cn == gb2312. chinese alias for GBK on win32 for gb2312 under Unix
    set encoding=chinese
    set termencoding=chinese
    set fileencoding=chinese
  elseif v:lang =~ "^zh_TW"
    " cp950, big5 or euc-tw
    " Are they equal to each other?
    set encoding=big5
    set termencoding=big5
    set fileencoding=big5
  endif
  " Detect UTF-8 locale, and replace CJK setting if needed
  if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
    set encoding=utf-8
    set termencoding=utf-8
    set fileencoding=utf-8
  endif
endif



"if you use vim in tty,
"'uxterm -cjk' or putty with option 'Treat CJK ambiguous characters as wide' on
if exists("&ambiwidth")
    set ambiwidth=double
endif

if has("gui_running")
    "set guioptions-=m		" 隐藏菜单栏
    set guioptions-=T		" 隐藏工具栏
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R

    if MySys()=="win32"
        set guifont=consolas:h14
        "start gvim maximized
        if has("autocmd")
            au GUIEnter * simalt ~x
        endif
    endif
    "let psc_style='cool'
    if v:version > 601
        "colorscheme ps_color
        "colorscheme default
        "colorscheme desert
        colorscheme darkblue
    endif
else
    if v:version > 601
        "set background=dark
        "colorscheme default
        colorscheme elflord
    endif
endif

"Some nice mapping to switch syntax (useful if one mixes different languages in one file)
map <leader>1 :set syntax=xml<cr>
map <leader>2 :set syntax=xhtml<cr>
map <leader>3 :set syntax=php<cr>
map <leader>4 :set ft=javascript<cr>
map <leader>5 :set ft=typescript<cr>
map <leader>6 :set ft=markdown<cr>
map <leader>7 :set ft=json<cr>
map <leader>$ :syntax sync fromstart<cr>

"Highlight current
if has("gui_running")
    if exists("&cursorline")
        set cursorline
    endif
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fileformat
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Favorite filetype
set ffs=unix,dos

nmap <leader>fd :se ff=dos<cr>
nmap <leader>fu :se ff=unix<cr>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM userinterface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set 7 lines to the curors - when moving vertical..
set so=7

"Turn on WiLd menu
set wildmenu

"Always show current position
set ruler

"The commandbar is 2 high
set cmdheight=2

"Show line number
set nu

"Do not redraw, when running macros.. lazyredraw
set lz

"Change buffer - without saving
set hid

"Set backspace
set backspace=eol,start,indent

"Bbackspace and cursor keys wrap to
set whichwrap+=<,>,h,l

"Ignore case when searching
set ignorecase
"set incsearch

"Set magic on
set magic

"No sound on errors.
set noerrorbells
set novisualbell
set t_vb=

"show matching bracet
set showmatch

"How many tenths of a second to blink
set mat=8

"Highlight search thing
set hlsearch

""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
"Format the statusline
" Nice statusbar
if performance_mode
else
    set laststatus=2
    set statusline=
    set statusline+=%2*%-3.3n%0*\ " buffer number
    set statusline+=%F\ " file name
    set statusline+=%h%1*%m%r%w%0* " flags
set statusline+=%= " right align
    set statusline+=[
    if v:version >= 600
        set statusline+=%{strlen(&ft)?&ft:'none'}, " filetype
        "set statusline+=%{&encoding}, " encoding
		set statusline+=%{(&fenc==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")},
    endif
    set statusline+=%{&fileformat}] " file format
    if filereadable(expand("$VIM/vimfiles/plugin/vimbuddy.vim"))
        set statusline+=\ %{VimBuddy()} " vim buddy
    endif
    set statusline+=%= " right align
    set statusline+=%2*0x%-8B\ " current char
    set statusline+=%-14.(%l,%c%V%)\ %<%P " offset

"set statusline=\ %<%F[%1*%M%*%n%R%H]%=\ %y\ %0(%{&fileformat}\ [%{(&fenc==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]\ %c:%l/%L%)

    " special statusbar for special windows
    if has("autocmd")
        au FileType qf
                    \ if &buftype == "quickfix" |
                    \ setlocal statusline=%2*%-3.3n%0* |
                    \ setlocal statusline+=\ \[Compiler\ Messages\] |
                    \ setlocal statusline+=%=%2*\ %<%P |
                    \ endif

        fun! FixMiniBufExplorerTitle()
            if "-MiniBufExplorer-" == bufname("%")
                setlocal statusline=%2*%-3.3n%0*
                setlocal statusline+=\[Buffers\]
                setlocal statusline+=%=%2*\ %<%P
            endif
        endfun

        if v:version>=600
            au BufWinEnter *
                        \ let oldwinnr=winnr() |
                        \ windo call FixMiniBufExplorerTitle() |
                        \ exec oldwinnr . " wincmd w"
        endif
    endif

    " Nice window title
    if has('title') && (has('gui_running') || &title)
        set titlestring=
        set titlestring+=%F\ " file name
        set titlestring+=%h%m%r%w " flags
        set titlestring+=\ -\ %{v:progname} " program name
    endif
endif



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around and tab
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Map space to / and c-space to ?
map <space> /

"Smart way to move btw. window
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l


"Tab configuration
map <leader>tn :tabnew %<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

if v:version>=700
    set switchbuf=usetab
endif

if exists("&showtabline")
    set stal=2
endif

"Moving fast to front, back and 2 sides ;)
imap <m-$> <esc>$a
imap <m-0> <esc>0i
imap <D-$> <esc>$a
imap <D-0> <esc>0i


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Autocommand
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Switch to current dir
map <leader>cd :cd %:p:h<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Parenthesis/bracket expanding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vnoremap $1 <esc>`>a)<esc>`<i(<esc>
")
vnoremap $2 <esc>`>a]<esc>`<i[<esc>
vnoremap $3 <esc>`>a}<esc>`<i{<esc>
vnoremap $$ <esc>`>a"<esc>`<i"<esc>
vnoremap $q <esc>`>a'<esc>`<i'<esc>
vnoremap $w <esc>`>a"<esc>`<i"<esc>

"Map auto complete of (, ", ', [
"http://www.vim.org/tips/tip.php?tip_id=153
"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Abbrev
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Comment for C like language
if has("autocmd")
    au BufNewFile,BufRead *.js,*.htc,*.c,*.tmpl,*.css ino $c /**<cr> **/<esc>O
endif

"My information
ia xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>
"iab xname Amir Salihefendic

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings etc.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remap VIM 0
map 0 ^

"Move a line of text using control
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if MySys() == "mac"
    nmap <D-j> <M-j>
    nmap <D-k> <M-k>
    vmap <D-j> <M-j>
    vmap <D-k> <M-k>
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command-line config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func! Cwd()
    let cwd = getcwd()
    return "e " . cwd
endfunc

func! DeleteTillSlash()
    let g:cmd = getcmdline()
    if MySys() == "unix" || MySys() == "mac"
        let g:cmd_edited = substitute(g:cmd, "(.*[/]).*", "", "")
    else
        let g:cmd_edited = substitute(g:cmd, "(.*[\]).*", "", "")
    endif
    if g:cmd == g:cmd_edited
        if MySys() == "unix" || MySys() == "mac"
            let g:cmd_edited = substitute(g:cmd, "(.*[/]).*/", "", "")
        else
            let g:cmd_edited = substitute(g:cmd, "(.*[\]).*[\]", "", "")
        endif
    endif
    return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
endfunc

"cno $q <C->eDeleteTillSlash()<cr>
"cno $c e <C->eCurrentFileDir("e")<cr>
"cno $tc <C->eCurrentFileDir("tabnew")<cr>
cno $th tabnew ~/
cno $td tabnew ~/Desktop/

"Bash like
cno <C-A> <Home>
cno <C-E> <End>
cno <C-K> <C-U>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Buffer realted
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Fast open a buffer by search for a name
"map <c-q> :sb

"Open a dummy buffer for paste
map <leader>q :e ~/buffer<cr>

"Restore cursor to file position in previous editing session
set viminfo='10,"100,:20,%,n~/.viminfo

" Buffer - reverse everything ... :)
"map <F9> ggVGg?

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files and backup
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Turn backup off
set nobackup
set nowb
"set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Enable folding, I find it very useful
if exists("&foldenable")
    set fen
	"set foldenable
	set foldmethod=indent
	"折叠相关的快捷键
	"zR 打开所有的折叠
	"za Open/Close (toggle) a folded group of lines.
	"zA Open a Closed fold or close and open fold recursively.
	"zi 全部 展开/关闭 折叠
	"zo 打开 (open) 在光标下的折叠
	"zc 关闭 (close) 在光标下的折叠
	"zC 循环关闭 (Close) 在光标下的所有折叠
	"zM 关闭所有可折叠区域
	" 设置折叠区域的宽度
	set foldcolumn=0
	" 设置折叠层数为
	setlocal foldlevel=1
	" 新建的文件，刚打开的文件不折叠
	autocmd! BufNewFile,BufRead * setlocal nofoldenable
	"set foldmethod=indent
endif

if exists("&foldlevel")
    set fdl=0
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text option
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" python script
"set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set backspace=2
set smarttab
set lbr
"set tw=500
set ts=2
set expandtab
set autoindent
"为不同的文件类型设置不同的空格数替换TAB
"autocmd FileType javascript,html,css,xml set ai
autocmd FileType html,css,json set ai
autocmd FileType html,css,json set sw=2
autocmd FileType html,css,json set ts=2
autocmd FileType html,css,json set sts=2

autocmd FileType javascript set ai
autocmd FileType javascript set sw=2
autocmd FileType javascript set ts=2
autocmd FileType javascript set sts=2

autocmd FileType typescript set ai
autocmd FileType typescript set sw=2
autocmd FileType typescript set ts=2
autocmd FileType typescript set sts=2


""""""""""""""""""""""""""""""
" => Indent
""""""""""""""""""""""""""""""
"Auto indent
set ai

"Smart indet
set si

"C-style indenting
if has("cindent")
    set cindent
endif

"Wrap line
set wrap


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>sn ]
map <leader>sp [
map <leader>sa zg
map <leader>s? z=



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
" => Yank Ring
""""""""""""""""""""""""""""""
if use_plugins_i_donot_use
    map <leader>y :YRShow<cr>

    """"""""""""""""""""""""""""""
    " => File explorer
    """"""""""""""""""""""""""""""
    "Split vertically
    let g:explVertical=1

    "Window size
    let g:explWinSize=35

    let g:explSplitLeft=1
    let g:explSplitBelow=1

    "Hide some file
    let g:explHideFiles='^.,.*.class$,.*.swp$,.*.pyc$,.*.swo$,.DS_Store$'

    "Hide the help thing..
    let g:explDetailedHelp=0


    """"""""""""""""""""""""""""""
    " => Minibuffer
    """"""""""""""""""""""""""""""
    let g:miniBufExplModSelTarget = 1
    let g:miniBufExplorerMoreThanOne = 0
    let g:miniBufExplModSelTarget = 0
    let g:miniBufExplUseSingleClick = 1
    let g:miniBufExplMapWindowNavVim = 1
    let g:miniBufExplVSplit = 25
    let g:miniBufExplSplitBelow=1

    "WindowZ
    map <c-w><c-t> :WMToggle<cr>
    let g:bufExplorerSortBy = "name"

    """"""""""""""""""""""""""""""
    " => LaTeX Suite thing
    """"""""""""""""""""""""""""""
    "set grepprg=grep -r -s -n
    let g:Tex_DefaultTargetFormat="pdf"
    let g:Tex_ViewRule_pdf='xpdf'

    if has("autocmd")
        "Binding
        au BufRead *.tex map <silent><leader><space> :w!<cr> :silent! call Tex_RunLaTeX()<cr>

        "Auto complete some things ;)
        au BufRead *.tex ino <buffer> $i indent
        au BufRead *.tex ino <buffer> $* cdot
        au BufRead *.tex ino <buffer> $i item
        au BufRead *.tex ino <buffer> $m [<cr>]<esc>O
    endif

endif

""""""""""""""""""""""""""""""
" => Tag list (ctags) - not used
""""""""""""""""""""""""""""""
"let Tlist_Ctags_Cmd = "/sw/bin/ctags-exuberant"
"let Tlist_Sort_Type = "name"
"let Tlist_Show_Menu = 1
"map <leader>t :Tlist<cr>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Filetype generic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Todo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"au BufNewFile,BufRead *.todo so ~/vim_local/syntax/amido.vim

""""""""""""""""""""""""""""""
" => VIM
""""""""""""""""""""""""""""""
if has("autocmd") && v:version>600
    au BufRead,BufNew *.vim map <buffer> <leader><space> :w!<cr>:source %<cr>
endif

""""""""""""""""""""""""""""""
" => HTML related
""""""""""""""""""""""""""""""
" HTML entities - used by xml edit plugin
let xml_use_xhtml = 1
"let xml_no_auto_nesting = 1

"To HTML
let html_use_css = 0
let html_number_lines = 0
let use_xhtml = 1


""""""""""""""""""""""""""""""
" => Ruby & PHP section
""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
""Run the current buffer in python - ie. on leader+space
"au BufNewFile,BufRead *.py so ~/vim_local/syntax/python.vim
"au BufNewFile,BufRead *.py map <buffer> <leader><space> :w!<cr>:!python %<cr>
"au BufNewFile,BufRead *.py so ~/vim_local/plugin/python_fold.vim

""Set some bindings up for 'compile' of python
"au BufNewFile,BufRead *.py set makeprg=python -c "import py_compile,sys; sys.stderr=sys.stdout; py_compile.compile(r'%')"
"au BufNewFile,BufRead *.py set efm=%C %.%#,%A File "%f", line %l%.%#,%Z%[%^ ]%@=%m
"au BufNewFile,BufRead *.py nmap <buffer> <F8> :w!<cr>:make<cr>

""Python iMap
"au BufNewFile,BufRead *.py set cindent
"au BufNewFile,BufRead *.py ino <buffer> $r return
"au BufNewFile,BufRead *.py ino <buffer> $s self
"au BufNewFile,BufRead *.py ino <buffer> $c ##<cr>#<space><cr>#<esc>kla
"au BufNewFile,BufRead *.py ino <buffer> $i import
"au BufNewFile,BufRead *.py ino <buffer> $p print
"au BufNewFile,BufRead *.py ino <buffer> $d """<cr>"""<esc>O

""Run in the Python interpreter
"function! Python_Eval_VSplit() range
" let src = tempname()
" let dst = tempname()
" execute ": " . a:firstline . "," . a:lastline . "w " . src
" execute ":!python " . src . " > " . dst
" execute ":pedit! " . dst
"endfunction
"au BufNewFile,BufRead *.py vmap <F7> :call Python_Eval_VSplit()<cr>


""""""""""""""""""""""""""""""
" => Cheetah section
"""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""
" => Java section
"""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""
" => JavaScript section
"""""""""""""""""""""""""""""""
"au BufNewFile,BufRead *.js so ~/vim_local/syntax/javascript.vim
"function! JavaScriptFold()
" set foldmethod=marker
" set foldmarker={,}
" set foldtext=getline(v:foldstart)
"endfunction
"au BufNewFile,BufRead *.js call JavaScriptFold()
"au BufNewFile,BufRead *.js imap <c-t> console.log();<esc>hi
"au BufNewFile,BufRead *.js imap <c-a> alert();<esc>hi
"au BufNewFile,BufRead *.js set nocindent
"au BufNewFile,BufRead *.js ino <buffer> $r return

"au BufNewFile,BufRead *.js ino <buffer> $d //<cr>//<cr>//<esc>ka<space>
"au BufNewFile,BufRead *.js ino <buffer> $c /**<cr><space><cr>**/<esc>ka


if has("eval") && has("autocmd")
    "vim 5.8.9 on mingw donot know what is <SID>, so I avoid to use function
    "c/cpp
    fun! Abbrev_cpp()
        ia <buffer> cci const_iterator
        ia <buffer> ccl cla
        ia <buffer> cco const
        ia <buffer> cdb bug
        ia <buffer> cde throw
        ia <buffer> cdf /** file<CR><CR>/<Up>
        ia <buffer> cdg ingroup
        ia <buffer> cdn /** Namespace <namespace<CR><CR>/<Up>
        ia <buffer> cdp param
        ia <buffer> cdt test
        ia <buffer> cdx /**<CR><CR>/<Up>
        ia <buffer> cit iterator
        ia <buffer> cns Namespace ianamespace
        ia <buffer> cpr protected
        ia <buffer> cpu public
        ia <buffer> cpv private
        ia <buffer> csl std::list
        ia <buffer> csm std::map
        ia <buffer> css std::string
        ia <buffer> csv std::vector
        ia <buffer> cty typedef
        ia <buffer> cun using Namespace ianamespace
        ia <buffer> cvi virtual
        ia <buffer> #i #include
        ia <buffer> #d #define
    endfunction

    fun! Abbrev_java()
        ia <buffer> #i import
        ia <buffer> #p System.out.println
        ia <buffer> #m public static void main(String[] args)
    endfunction

    fun! Abbrev_python()
        ia <buffer> #i import
        ia <buffer> #p print
        ia <buffer> #m if __name__=="__main__":
    endfunction

    fun! Abbrev_aspvbs()
        ia <buffer> #r Response.Write
        ia <buffer> #q Request.QueryString
        ia <buffer> #f Request.Form
    endfunction

    fun! Abbrev_js()
        ia <buffer> #a if(!0){throw Error(callStackInfo());}
    endfunction

    augroup abbreviation
        au!
        au FileType javascript :call Abbrev_js()
        au FileType cpp,c :call Abbrev_cpp()
        au FileType java :call Abbrev_java()
        au FileType python :call Abbrev_python()
        au FileType aspvbs :call Abbrev_aspvbs()
    augroup END
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remove the Windows ^M
noremap <leader>m :%s/\r//g<CR>

"Paste toggle - when pasting something in, don't indent.
"set pastetoggle=<F3>

"Remove indenting on empty line
map <F2> :%s/s*$//g<cr>:noh<cr>''

"Super paste
ino <C-v> <esc>:set paste<cr>mui<C-R>+<esc>mv'uV'v=:set nopaste<cr>

"clipboard with xclip
if MySys() == "unix"
    vmap <F6> :!xclip -sel c<CR>
    map <F7> :-1r!xclip -o -seln c<CR>'z
endif

"add by waiting
" shift tab pages
map <S-Left> :tabp<CR>
map <S-Right> :tabn<CR>
map<Up> gk
map<Down> gj
" CTRL-V and SHIFT-Insert are Paste
"map <C-V>		"+gP
map <S-Insert>		"+gP
"cmap <C-V>		<C-R>+
cmap <S-Insert>		<C-R>+

" Use CTRL-S for saving, also in Insert mode
noremap <C-S>		:update<CR>
vnoremap <C-S>		<C-C>:update<CR>
inoremap <C-S>		<C-O>:update<CR>

" CTRL-F4 is Close window
noremap <C-F4> <C-W>c
inoremap <C-F4> <C-O><C-W>c
cnoremap <C-F4> <C-C><C-W>c
onoremap <C-F4> <C-C><C-W>c

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y

set smartindent

"for ctags
set tags=tags;
set autochdir

   if MySys() == "windows"                "设定windows系统中ctags程序的位置
     let Tlist_Ctags_Cmd = 'ctags'
   elseif MySys() == "linux"              "设定windows系统中ctags程序的位置
     let Tlist_Ctags_Cmd = '/usr/bin/ctags'
   endif
   let Tlist_Show_One_File = 1            "不同时显示多个文件的tag，只显示当前文件的
   let Tlist_Exit_OnlyWindow = 1          "如果taglist窗口是最后一个窗口，则退出vim
   let Tlist_Use_Right_Window = 1         "在右侧窗口中显示taglist窗口

"""""""""" Spell check on """"""""""
set spell spelllang=en_us
setlocal spell spelllang=en_us
highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline

ia tihs this

" 括号自动匹配添加
inoremap ( ()<LEFT>
inoremap { {}<LEFT>
inoremap [ []<LEFT>
" inoremap ' ''<LEFT>
" inoremap " ""<LEFT>

let g:javascript_plugin_jsdoc = 1
set conceallevel=1

" nerdcommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" syntax 配置
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 0
"let g:syntastic_check_on_wq = 0
"let g:syntastic_javascript_checkers = ['eslint']
"let g:syntastic_javascript_eslint_exec = 'eslint'

"call pathogen#infect()



filetype off                  " required

" 启用vundle来管理vim插件
set rtp+=~/.vim/bundle/vundle.vim
"call vundle#begin()
" 安装插件写在这之后

" let Vundle manage Vundle, required
"Plugin 'VundleVim/Vundle.vim'

" 如果你的插件来自github，写在下方，只要作者名/项目名就行了
" Plugin 'Valloric/YouCompleteMe'
"Plugin 'vim-syntastic/syntastic'


"call vundle#end()            " required
filetype plugin on    " required
" 常用命令
" :PluginList       - 查看已经安装的插件
" :PluginInstall    - 安装插件
" :PluginUpdate     - 更新插件
" :PluginSearch     - 搜索插件，例如 :PluginSearch xml就能搜到xml相关的插件
" :PluginClean      - 删除插件，把安装插件对应行删除，然后执行这个命令即可
" h: vundle         - 获取帮助


nnoremap <silent> <F3> :Grep<CR>
inoremap jj <Esc>

" F9 切换粘贴模式
set pastetoggle=<F9>

"if !exists("g:ycm_semantic_triggers")
"  let g:ycm_semantic_triggers = {}
"endif
"let g:ycm_semantic_triggers['typescript'] = ['.']


" autocmd FileType javascript set formatprg=prettier-eslint\ --stdin
" 保存时自动格式化
" autocmd BufWritePre *.js :normal gggqG


" 临时文件目录
" mkdir -p ~/.vim/
set directory=~/.vim//

