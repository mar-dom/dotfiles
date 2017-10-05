set nocompatible

execute pathogen#infect()

syntax on
set background=dark
colorscheme solarized

filetype plugin on
filetype indent on

set mouse-=a
set autoindent
set showmatch
set ignorecase
set hlsearch
set cursorline
set incsearch
set encoding=utf-8
set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4
set ruler
set number
set nowrap
set nobackup
set noswapfile
set laststatus=2
set noshowmode
"set t_co=16

" Use CTRL-S for saving, also in Insert mode
noremap <C-S>   :update<CR>
vnoremap <C-S>  <C-C>:update<CR>
inoremap <C-S>  <C-O>:update<CR>

noremap <C-Q>   :quit!<CR>
vnoremap <C-Q>  <C-C>:quit!<CR>
inoremap <C-Q>  <C-O>:quit!<CR>

let g:solarized_termtrans = 1
let g:solarized_termcolors=16

let NERDTreeShowHidden = 1
map <F5> :NERDTreeToggle<cr>

let g:lightline = {
      \ 'colorscheme':  'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename' , 'modified'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'filetype': 'MyFiletype',
      \   'fileformat': 'MyFileformat',
      \ },
      \ }

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

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

