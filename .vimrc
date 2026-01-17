set nocompatible

filetype plugin indent on
syntax on

" set clipboard+=unnamedplus
set modeline
set hidden
" set shada=''
set updatetime=300
set autochdir
set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set cmdheight=2
" set complete-=i
" set completeopt=menu,menuone,noselect
set display=lastline
set encoding=utf-8
set expandtab
" set history=10000
set incsearch
set langnoremap
set laststatus=1
set linebreak
set mouse=a
set nobackup
set nohlsearch
set noswapfile
set notermguicolors
set nowritebackup
set ruler
set scrolloff=1
set shiftwidth=2
set shortmess+=c
set showcmd
set signcolumn=no
set smarttab
set softtabstop=2
set splitbelow
set splitright
set ttyfast
" set viminfo='0,h ",n~/.cache/viminfo
set wildmenu
set wildmode=lastused,full
set wildoptions=
set wrap

if !has('nvim')
  set ttymouse=xterm2
endif

let g:mapleader = "\<C-x>"
let g:maplocalleader = "\<C-x>"

cnoremap <C-g> <C-c>
nnoremap [b :bprev<CR>
nnoremap ]b :bnext<CR>
nnoremap q :q<CR>
noremap <F1> <Nop>
noremap j gj
noremap k gk
tnoremap <Esc> <C-\><C-n>
nnoremap <M-,> <C-t>
noremap <C-a> <Home>
noremap <C-e> <End>
inoremap <C-a> <Home>
inoremap <C-e> <End>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
imap <C-w> <Esc><C-w>
inoremap <M-i> <C-x><C-o>

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Esc> pumvisible() ? "\<C-e>\<Esc>" : "\<Esc>"
inoremap <expr> <C-g> pumvisible() ? "\<C-e>" : "\<C-g>"

command! Terminal :split<CR>|:terminal

augroup my.viml
  autocmd!
  autocmd FileType gitconfig setl noet sw=8
  autocmd BufRead,BufNewFile *.pod setl filetype=systemd
  autocmd BufRead,BufNewFile *.container setl filetype=systemd
  autocmd BufRead,BufNewFile *.volume setl filetype=systemd
  autocmd BufRead,BufNewFile *.network setl filetype=systemd
  autocmd FileType lua,vim setl keywordprg=:help
  autocmd FileType help nnoremap <buffer> <CR> <C-]>
augroup END
