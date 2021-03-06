call plug#begin('~/.vim/plugged')

Plug 'lifepillar/vim-solarized8'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-syntastic/syntastic'
Plug 'junegunn/fzf'
Plug 'sbdchd/neoformat'
Plug 'janko-m/vim-test'
Plug 'sheerun/vim-polyglot'

call plug#end()

set encoding=utf-8
set nocompatible
set hidden
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set nowrap
set incsearch
set hlsearch
set showmatch
set ignorecase smartcase
set switchbuf=useopen
set scrolloff=5
set nobackup
set nowritebackup
set noswapfile
set backspace=indent,eol,start
set winwidth=105
set termguicolors
set background=dark
set list listchars=tab:»·,trail:· " Display extra whitespace
set laststatus=2
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

set mouse=

colorscheme solarized8

let mapleader = ","
let maplocalleader = " "

inoremap <c-c> <esc>
nnoremap <silent> <c-c> :nohlsearch<CR>
nnoremap <leader>w :w<CR>
nnoremap <silent> <leader>e :Explore<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>f :FZF<CR>

let test#strategy = "vimterminal"
nnoremap <silent> <leader>s :TestNearest<CR>
nnoremap <silent> <leader>a :TestFile<CR>
nnoremap <silent> <leader>l :TestLast<CR>
