" Init
set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'scrooloose/nerdtree'
    Plugin 'sheerun/vim-polyglot'
    Plugin 'ryanoasis/vim-devicons'
    Plugin 'mhinz/vim-startify'
    Plugin 'tpope/vim-fugitive'
    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'
call vundle#end()            " required
filetype plugin indent on    " required

" Sets
set mouse-=a
set encoding=utf-8
set hidden "hiddes buffers instead of closing them
set nobackup
set noswapfile
set showmatch "show search matches
set ignorecase
set hlsearch
set incsearch
set expandtab
set shiftwidth=4
set softtabstop=4
set nowrap "no line wrap
set rnu "relative line numbers
set cursorline
set noshowmode
set pastetoggle=<F2>
" no auto-indenting
set noautoindent
set nocindent
set nosmartindent
set indentexpr=
filetype indent off
filetype plugin indent off

" leader key
let mapleader = ","

" Use CTRL-S for saving, also in Insert mode
noremap <C-S>   :update<CR>
vnoremap <C-S>  <C-C>:update<CR>
inoremap <C-S>  <C-O>:update<CR>

noremap <C-Q>   :quit!<CR>
vnoremap <C-Q>  <C-C>:quit!<CR>
inoremap <C-Q>  <C-O>:quit!<CR>

" Toggle line numbers
function! NumberToggle()
    if &relativenumber
           set norelativenumber
      else
           set relativenumber
      endif
endfunction
nnoremap <F3> :call NumberToggle()<CR>

" Buffer keymaps
function SwitchBuffer()
  b#
endfunction
nmap <Tab> :call SwitchBuffer()<CR>
" To open a new empty buffer
nmap <leader>t :enew<cr>
" Move to the next buffer
nmap <leader>n :bnext<CR>
" Move to the previous buffer
nmap <leader>m :bprevious<CR>
" Close the current buffer and move to the previous one
nmap <leader>q :bp <BAR> bd #<CR>
" Show all open buffers and their status
nmap <leader>l :ls<CR>

" Solarized Setup
syntax on
let g:solarized_termtrans = 1
set background=dark
colorscheme solarized

" Nerdtree Setup
let NERDTreeShowHidden = 1
map <F5> :NERDTreeToggle<cr>

" Startify Setup
let g:startify_list_order = [
            \ ['   Most recently used files:'],
            \ 'files',
            \ ['   Most recently used files in the current directory:'],
            \ 'dir',
            \ ['   These are my sessions:'],
            \ 'sessions',
            \ ['   These are my bookmarks:'],
            \ 'bookmarks',
            \ ['   These are my commands:'],
            \ 'commands',
\ ]
let g:startify_fortune_use_unicode = 1

" Airline Setup
let g:airline_solarized_bg='dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
