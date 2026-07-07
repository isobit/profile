-- Plugins (managed by vim.pack, built into Neovim 0.12+)
-- Run :lua vim.pack.update() to install/update
vim.pack.add({
	-- Editing
	'https://github.com/tpope/vim-abolish',       -- :S smart substitute (understands capitalization)
	'https://github.com/tpope/vim-sleuth',        -- Autodetect tabbing
	'https://github.com/tpope/vim-speeddating',   -- Datetime incrementing
	'https://github.com/tpope/vim-surround',      -- cs to change surrounding delimiters
	'https://github.com/godlygeek/tabular',       -- :Tab to align given format
	'https://github.com/windwp/nvim-autopairs',   -- Auto-close brackets/quotes

	-- FZF
	'https://github.com/junegunn/fzf',
	'https://github.com/junegunn/fzf.vim',

	-- File explorer
	'https://github.com/preservim/nerdtree',

	-- Languages
	'https://github.com/neovim/nvim-lspconfig',

	-- Colors
	'https://github.com/isobit/vim-darcula-colors',
})

-- Auto-close brackets, parens, and quotes as you type
require('nvim-autopairs').setup({})

-- ================ General Config ====================

vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.mouse = 'a'
vim.opt.modelines = 5
vim.opt.spell = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.fillchars = ''

-- Reload files changed outside vim
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI', 'FileChangedShell' }, {
	command = 'silent! checktime',
})

-- Theme
vim.cmd('silent! colorscheme darcula')

-- Vertical split character
vim.opt.listchars = { eol = '$', tab = '>-', trail = '·', extends = '>', precedes = '<', space = '·' }

-- Don't clutter working directories with backup and swap files
vim.opt.directory = vim.fn.expand('~/.vim/backups//')
vim.opt.backupdir = vim.fn.expand('~/.vim/backups')
vim.opt.undodir = vim.fn.expand('~/.vim/backups')
vim.opt.undofile = true

-- Scrolling
vim.opt.sidescroll = 1
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 15

-- Disable bell
vim.opt.errorbells = false
vim.opt.visualbell = true

-- Don't show preview window for completions
vim.opt.completeopt = { 'menu', 'menuone', 'fuzzy', 'noselect', 'popup' }

-- Tab triggers/navigates completion, Shift-Tab goes back (SuperTab style)
vim.keymap.set('i', '<Tab>', function()
	if vim.fn.pumvisible() == 1 then
		return '<C-n>'
	end
	local col = vim.fn.col('.') - 1
	if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
		return '<Tab>'
	end
	if next(vim.lsp.get_clients({ bufnr = 0 })) then
		return '<C-x><C-o>'
	end
	return '<C-n>'
end, { expr = true, noremap = true })
vim.keymap.set('i', '<S-Tab>', function()
	if vim.fn.pumvisible() == 1 then
		return '<C-p>'
	end
	return '<S-Tab>'
end, { expr = true, noremap = true })

-- ================ Search ============================

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- ================ Indentation =======================

-- Use tabs with a width of 4 by default (vim-sleuth overrides per-file)
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- SetTab command for manual override
vim.api.nvim_create_user_command('SetTab', function(opts)
	local n = tonumber(opts.args)
	if n then
		vim.opt.expandtab = true
		vim.opt.tabstop = n
		vim.opt.softtabstop = n
		vim.opt.shiftwidth = n
	else
		vim.opt.expandtab = false
		vim.opt.tabstop = 4
		vim.opt.softtabstop = 4
		vim.opt.shiftwidth = 4
	end
end, { nargs = '?' })

-- C indentation style
vim.opt.cinoptions = 'l1,h0,t0,(0,Ws,m1,j1,J1,*500,)500'

-- ================ Line Wrapping =====================

vim.opt.textwidth = 79
vim.opt.wrap = false
vim.opt.formatoptions = 'croqn'
vim.opt.linebreak = true

-- ================ Folds =============================

vim.opt.foldmethod = 'manual'
vim.opt.foldenable = false

-- ================ Command Completion ================

vim.opt.wildmode = 'list:longest'
vim.opt.wildignore = {
	'*.o', '*.obj', '*~', '*.pyc', '*.egg-info',
	'*vim/backups*', '*sass-cache*', '*DS_Store*',
	'vendor/rails/**', 'vendor/cache/**', '*.gem',
	'log/**', 'tmp/**', '*.png', '*.jpg', '*.gif',
}

-- ================ Highlights ========================

local vimrc_group = vim.api.nvim_create_augroup('vimrc', { clear = true })

-- Highlight trailing whitespace (hide in insert mode)
vim.api.nvim_create_autocmd('InsertEnter', {
	group = vimrc_group,
	callback = function()
		vim.w.tws_match = vim.w.tws_match or nil
		if vim.w.tws_match then
			vim.fn.matchdelete(vim.w.tws_match)
			vim.w.tws_match = nil
		end
	end,
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead', 'InsertLeave' }, {
	group = vimrc_group,
	callback = function()
		if not vim.w.tws_match then
			local ok, id = pcall(vim.fn.matchadd, 'TrailingWhitespace', [[\s\+$]])
			if ok then vim.w.tws_match = id end
		end
	end,
})

-- Highlight NOCOMMIT like TODO
vim.api.nvim_create_autocmd('Syntax', {
	group = vimrc_group,
	command = 'syn keyword Todo contained NOCOMMIT',
})

-- Highlight characters past textwidth
vim.api.nvim_create_autocmd('FileType', {
	group = vimrc_group,
	callback = function()
		local tw = vim.bo.textwidth
		if tw > 0 then
			pcall(vim.cmd, string.format([[match OverLength /\%%%dv.\+/]], tw + 1))
		end
	end,
})

-- ================ Utilities =========================

-- CleanWhitespace command
vim.api.nvim_create_user_command('CleanWhitespace', function()
	local search = vim.fn.getreg('/')
	vim.cmd([[%s/\s\+$//e]])
	vim.fn.setreg('/', search)
end, {})

-- Wrap toggle
vim.api.nvim_create_user_command('WrapToggle', function()
	vim.opt.wrap = not vim.wo.wrap
end, {})

-- ================ Filetype fixes ====================

-- Spell checking in git commits
vim.api.nvim_create_autocmd('FileType', {
	group = vimrc_group,
	pattern = 'gitcommit',
	callback = function() vim.opt_local.spell = true end,
})

-- Go HTML template detection
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
	group = vimrc_group,
	pattern = '*.html',
	callback = function()
		if vim.fn.search('{{', 'nw') ~= 0 then
			vim.bo.filetype = 'gohtmltmpl'
		end
	end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
	group = vimrc_group,
	pattern = '*.tmpl',
	callback = function() vim.bo.filetype = 'gotexttmpl' end,
})

-- SQL commenting
vim.api.nvim_create_autocmd('FileType', {
	group = vimrc_group,
	pattern = 'sql',
	callback = function() vim.bo.commentstring = '-- %s' end,
})

-- ================ Mappings ==========================


-- NERDTree
vim.keymap.set('n', '<leader>t', '<cmd>NERDTreeToggle<cr>')
vim.keymap.set('n', '<leader>h', '<cmd>NERDTreeFind<cr>')

-- Window navigation
vim.keymap.set('n', 'gk', '<cmd>wincmd k<cr>', { silent = true })
vim.keymap.set('n', 'gj', '<cmd>wincmd j<cr>', { silent = true })
vim.keymap.set('n', 'gh', '<cmd>wincmd h<cr>', { silent = true })
vim.keymap.set('n', 'gl', '<cmd>wincmd l<cr>', { silent = true })

-- \w to toggle line wrapping
vim.keymap.set('n', '<leader>w', '<cmd>WrapToggle<cr>')

-- \g to go to buffer
vim.keymap.set('n', '<leader>g', ':ls<cr>:b', { silent = false })

-- \c clears quickfix and search highlight
vim.keymap.set('n', '<leader>c', '<cmd>call setqflist([])<cr><cmd>noh<cr>')

-- n/N navigate quickfix when active
vim.keymap.set('n', 'n', function()
	if #vim.fn.getqflist() > 0 then
		vim.cmd('cn')
	else
		return 'n'
	end
end, { expr = true })
vim.keymap.set('n', 'N', function()
	if #vim.fn.getqflist() > 0 then
		vim.cmd('cp')
	else
		return 'N'
	end
end, { expr = true })

-- FZF
vim.keymap.set('n', '<leader>o', '<cmd>Files<cr>')
vim.keymap.set('n', '<leader>f', '<cmd>RG<cr>')
vim.keymap.set('v', '<leader>f', '"sy:RG <c-r>s<cr>')
vim.keymap.set('n', '<leader>F', 'viw"sy:RG <c-r>s<cr>')

-- Substitution
vim.keymap.set('v', '<leader>s', '"sy:%s/<c-r>s//gc<left><left><left>', { silent = false })
vim.keymap.set('v', '<leader>S', '"sy:%s/<c-r>s//g<left><left>', { silent = false })

-- \l to yank filename:lineno into clipboard
vim.keymap.set('n', '<leader>l', function()
	vim.fn.setreg('+', vim.fn.expand('%:p') .. ':' .. vim.fn.line('.'))
end)

-- J to join line (visual)
vim.keymap.set('v', 'J', ':left<cr>gv:join!<cr>gv:s/,/, /ge<cr>gv=gv:s/\\s\\+$//e<cr>')

-- K to split line (visual)
vim.keymap.set('v', 'K', '<esc>o<esc>mkgv:s/\\([({}\\[,]\\)/\\1\\r/ge<cr>`<v`k:s/\\([)}\\]]\\)/\\r\\1/ge<cr>`<v`k=`kddk')

-- Tabularize shortcuts
vim.keymap.set('v', '<leader>a=', ':Tabularize /=<cr>')
vim.keymap.set('v', '<leader>a:', ':Tabularize /:\\zs<cr>')
vim.keymap.set('v', '<leader>as', ':Tabularize multiple_spaces<cr>')

-- :w!! to sudo write
vim.cmd([[cmap w!! w !sudo tee % >/dev/null]])

-- :W is :w
vim.cmd([[cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))]])

-- Don't replace paste buffer when pasting over a selection
vim.keymap.set('v', 'p', '"_dP')

-- FZF ctrl-a/ctrl-q to select all and build quickfix list
vim.g.fzf_action = {
	['ctrl-q'] = function(lines)
		vim.fn.setqflist(vim.tbl_map(function(l) return { filename = l } end, lines))
		vim.cmd('copen')
		vim.cmd('cc')
	end,
	['ctrl-t'] = 'tab split',
	['ctrl-x'] = 'split',
	['ctrl-v'] = 'vsplit',
}
vim.env.FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

-- ================ LSP ===============================

-- LSP navigation
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)           -- built-in: gd (same)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)          -- built-in: gD (same)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)           -- built-in: grr

-- LSP diagnostics
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float) -- built-in: <C-W>d
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP info
vim.keymap.set('n', '<leader>i', vim.lsp.buf.hover)         -- built-in: K

-- LSP actions
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename)        -- built-in: grn
vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action)   -- built-in: gra

-- ================ Tree-sitter ====================

vim.api.nvim_create_autocmd('FileType', {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})


-- ================ File Explorer ==================

vim.g.NERDTreeIgnore = { '\\.o$', '\\.pyc$', '\\.egg-info$', '^__pycache__$' }
vim.g.NERDTreeCaseSensitiveSort = 1

-- Auto-mirror NERDTree into new tabs
vim.api.nvim_create_autocmd('TabNewEntered', {
	group = vimrc_group,
	callback = function()
		if vim.fn.exists('t:NERDTreeBufName') == 0 then
			pcall(vim.cmd, 'NERDTreeMirror')
			vim.cmd('wincmd p')
		end
	end,
})

-- Close tab if NERDTree is the only window left
vim.api.nvim_create_autocmd('BufEnter', {
	group = vimrc_group,
	callback = function()
		if vim.fn.winnr('$') == 1 and vim.b.NERDTree and vim.b.NERDTree.isTabTree then
			vim.schedule(function()
				if vim.fn.tabpagenr('$') > 1 then
					vim.cmd('tabclose')
				else
					vim.cmd('quit')
				end
			end)
		end
	end,
})

-- ================ LSP Servers ====================

vim.lsp.log.set_level('OFF')

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = false })
		end
	end,
})

if vim.fn.executable('go') == 1 then
	vim.lsp.enable('gopls')
end

vim.lsp.config('nixd', {
	settings = {
		nixd = {
			formatting = { command = { 'alejandra' } },
		},
	},
})
vim.lsp.enable('nixd')

vim.lsp.config('yamlls', {
	settings = {
		yaml = {
			keyOrdering = false,
			schemaStore = {
				enable = true,
			},
		}
	}
})

vim.lsp.enable('pylsp')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('terraformls')
vim.lsp.enable('cue')
vim.lsp.enable('yamlls')

-- ================ Local config ======================

vim.opt.secure = true
vim.opt.exrc = true

local local_config = vim.fn.expand('~/.config/nvim/local.lua')
if vim.fn.filereadable(local_config) == 1 then
	dofile(local_config)
end
