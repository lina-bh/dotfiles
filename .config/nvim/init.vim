set nohlsearch
set splitright
set splitbelow
set linebreak
set signcolumn=no
set mouse=a
set nowritebackup
" set updatetime=300
set noswapfile
" set shada=''
set laststatus=1

set expandtab
set softtabstop=2

let g:mapleader = ','

noremap j gj
noremap k gk
noremap <F1> <Nop>
nnoremap q <Nop>

augroup FileHooks
  autocmd!
augroup END

colorscheme vim

lua require('plugins')
