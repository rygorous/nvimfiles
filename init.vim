if has("win32")
	set guifont=Consolas:h10
endif

" Various GUI/editing options
set nowrap
set ruler
set showmode
set wildmenu

set nobackup
set noswapfile

set laststatus=3
set cmdheight=2

let mapleader=","

" Tab/indent settings
set autoindent
set expandtab
set smarttab
set cino=:0l1g0t0(0

" Wildcard ignores
set wildignore=*.o,*.obj,*.a,*.lib,*.exe,*.pdb,*.map

" Use Ripgrep when available
if executable("rg")
	set grepprg=rg\ --color\ never
endif

" Very janky CDep setup
set makeprg=fgb\ -onlywin64-msvc\ -r

" Quickfix mappings
nmap <F8> :cnext<CR>
nmap <S-F8> :cprevious<CR>

" CUA-style copy & paste to system buffer
vmap <C-Insert> "*y<CR>
vmap <C-Delete> "*d<CR>
nmap <S-Insert> "*P<CR>
vmap <S-Insert> "*P<CR>

" Indent styles
command! CbInd set ts=4 sts=4 sw=4 noet
command! FgInd set ts=4 sts=4 sw=4 et
command! JrInd set ts=2 sts=2 sw=2 et
command! SbInd set ts=3 sts=3 sw=3 et

" Default to Charles' style for Oodle
:CbInd

" Plugins
call plug#begin()

Plug 'tomasr/molokai'
Plug 'jnurmine/Zenburn'
Plug 'tpope/vim-fugitive'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'neomake/neomake'

call plug#end()

colorscheme zenburn

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <leader>m <cmd>Neomake!<cr>

" Disable auto-continuation of comments
au FileType c,cpp setlocal formatoptions-=c formatoptions-=r formatoptions-=o
