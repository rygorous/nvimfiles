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

" Hybrid line numbers, used as sign column too
set number
set relativenumber
set signcolumn=number

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

" Turn off autohighlight by hitting return
nnoremap <CR> :nohl<CR><CR>

" CUA-style copy & paste to system buffer
vmap <C-Insert> "*y<CR>
vmap <C-Delete> "*d<CR>
nmap <S-Insert> "*P<CR>
vmap <S-Insert> "*P<CR>

" Window navigation
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

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
Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/rust-tools.nvim'

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
au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Neomake config
"let g:neomake_open_list = 2

" Lualine init
lua << LUAEND
require('telescope').setup {
}

require('telescope').load_extension('fzf')
require('lualine').setup {
	options = {
		theme = 'powerline'
	}
}

require('nvim-treesitter.configs').setup {
	ensure_installed = { "c", "cpp", "lua", "rust", "go", "hlsl", "javascript", "json", "latex", "make", "sql", "toml", "vim", "yaml" },
	highlight = {
		enable = true
	},
}

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local lsp_on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local rt = require('rust-tools')

rt.setup({
	server = {
		on_attach = function(client, bufnr)
			lsp_on_attach(client, bufnr)
			vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
			vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
		end,
	},
})

LUAEND
