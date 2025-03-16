set nohlsearch
set splitright
set splitbelow
set linebreak
set signcolumn=no
set mouse=a
set nowritebackup
" set updatetime=300
set noswapfile
" set shada=
set laststatus=1

noremap j gj
noremap k gk
noremap <F1> <Nop>
nnoremap q <Nop>

augroup FileHooks
  autocmd!
  autocmd FileType vim setl sw=2 sts=2 et
  autocmd FileType nix setl sw=2 sts=2 et
augroup END

colorscheme vim
