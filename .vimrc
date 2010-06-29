
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set tabstop=4

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set nohls
  set laststatus=2
  set background=light
  colorscheme autumn
endif


" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
	
  autocmd BufWRitePre *.php call s:BufferWritePre()
  autocmd BufWRitePost *.php call s:BufferWritePost()

  augroup END

else

  set noautoindent		" always set autoindenting on
  set smartindent
  set nocindent
  set showmatch

  set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
endif " has("autocmd")

"Function: BufferWritePre()
" EOL markers are not desired, change to binary mode before saving so one isn't added
function s:BufferWritePre()
        "clear trailing whitespace
        :%s/\(\*\)\@<!\s\+$//ge
        :%s/\s\s*$//ge
        exe "norm :silent %s/\\s\\s*$//e\<CR>"
        "set to binary and remove eol
        let b:save_bin = &bin
        let &l:bin = 1 
        let &l:eol = 0 
endfunction

function s:BufferWritePost()
        let &l:bin = b:save_bin
endfunction

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set number
let loaded_matchparen=1

set autowrite
set backupdir=/tmp
set directory=/tmp

nmap tn :tabnext<CR>
nmap tp :tabprev<CR>
nmap to :tabnew .<CR>
nmap te :tabedit 
nmap tz :tabclose<CR>
nmap tf :tabfind **/
nmap tml :tabmove<CR>
nmap tmf :tabmove 0 <CR>

nmap do :open .<CR>
nmap dz :close<CR>

au BufNewFile,BufRead *.ctp set filetype=php
au BufNewFile,BufRead *.php set filetype=php

au FileType php set tabstop=4
au FileType php set shiftwidth=4
au FileType php set noexpandtab

au FileType php set autoindent
au FileType php set cindent
au Filetype php set cinoptions=(1s

au FileType php set omnifunc=phpcomplete#CompletePHP
au FileType php set makeprg=php\ -l\ %
au FileType php set errorformat=%m\ in\ %f\ on\ line\ %l

let php_sql_query=0
let php_htmlInStrings=0
let php_folding=3
let php_smart_members=0
let php_alt_properties=1
let php_large_file=2000
"set foldmethod=indent

" PHP Online Documentation
au FileType php noremap fd :!open http://php.net/<cword><CR><CR>

let g:phpdoc_DefineAutoCommands = 0
let g:phpdoc_tags = {
            \   'class' : {
            \       'copyright' :   'Copyright ' . strftime('%Y') . ' Company',
			\ 		'license' :  'http://opensource.org/licenses/bsd-license.php The BSD License'
            \   },
            \   'function' : {
            \   },
            \   'property' : {
            \   }
            \}

" inoremap <C-P> <ESC>:call PHPDOC_DecideClassOrFunc()<CR>i
nnoremap <C-P> :call PHPDOC_DecideClassOrFunc()<CR>
vnoremap <C-P> :call PHPDOC_DecideClassOrFunc()<CR> 

function! Paste(mode)
  if a:mode == "v"
    normal gv
    normal "+P
    normal l
  elseif a:mode == "i"
    set virtualedit=all
    normal `^"+gP
    let &virtualedit = ""
  endif
endfunction

vnoremap <C-X> "+d
vnoremap <C-C> "+y
nnoremap <C-V> "+gPl
vnoremap <C-V> :<C-U>call Paste("v")<CR>
inoremap <C-V> <C-O>:call Paste("i")<CR>
noremap <C-Z> :undo<CR>

imap ø <C-]>
imap å <C-[>
let mapleader = "æ"

"Abbrivations
ab pf public function () {{<up><right><right><right><right><right><right><right><right><right><right><right><right>
ab psf public static function () {{<up><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right>
ab e echo
ab tf $this->form->
ab tff $this->form->field();<left>
ab th $this->html->
ab tl $this->lists->
ab tla $this->lists->add('main', '');<left><left><left>
ab tlae $this->lists->addElement('main', );<left><left>
ab tlg $this->lists->generate('main');<left><left><left><left><left><left><left>
ab t $this->
ab ex $expected = 
ab exa $expected = array(<cr><cr><bs>);<up><right>
ab res $result = 
ab dtr dt($result);
ab dte dt($expeced);
