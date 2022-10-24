if has("win32")
	set guifont=Consolas:h10
	" Ctrl-Z on Windows suspends the process with no way to resume it, so
	" don't do that
	nmap <C-z> <Nop>
endif

" Various GUI/editing options
set nowrap
set ruler
set showmode
set wildmenu

set nobackup
set noswapfile

set laststatus=2
set cmdheight=2

let mapleader=","

" Hybrid line numbers
set number
set relativenumber

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
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
"Plug 'neomake/neomake'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
if has("win32")
	Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
else
	Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
endif
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

call plug#end()

" Zenburn but change the VertSplit color which by default is terrible
colorscheme zenburn
hi VertSplit guifg=#5b605e guibg=#3f3f3f ctermfg=240 ctermbg=237

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <leader>m <cmd>Neomake!<cr>

" Disable auto-continuation of comments
au FileType c,cpp setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Neomake config
"let g:neomake_open_list = 2

" Lualine init
lua << END
require('telescope').setup {
}

require('telescope').load_extension('fzf')
require('lualine').setup {
	options = {
		theme = 'powerline'
	}
}
END
