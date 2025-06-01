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
set nowildmenu
set wildmode=longest,list
set autochdir
set softtabstop=2
set shiftwidth=2
set expandtab
set notermguicolors

let g:mapleader = ','

noremap j gj
noremap k gk
noremap <F1> <Nop>
nnoremap q <Nop>

augroup FileHooks
  autocmd!
  autocmd FileType gitconfig setl noet sw=8
augroup END

colorscheme vim

lua require('plugins')
