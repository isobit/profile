-- ================ LSP ======================

local lsp_flags = {
	-- This will be the default in neovim 0.7+
	debounce_text_changes = 150,
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local lsp_on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local lsp_config = {
	efm = {
		cmd = { 'efm-langserver', '-loglevel', '10' },
		-- single_file_support = false,
		filetypes = {
			'csv',
			'dockerfile',
			'eruby',
			'json',
			'lua',
			'make',
			'markdown',
			'python',
			'sh',
			'vim',
			'yaml',
		},
	},
	gopls = {},
	solargraph = {},
	terraformls = {},
	yamlls = {},

}
for key, val in pairs(lsp_config) do
	val.on_attach = lsp_on_attach
	val.flags = lsp_flags
	require('lspconfig')[key].setup(val)
end

-- =============== tree-sitter ================
--require'nvim-treesitter.configs'.setup {
--	highlight = {
--		enable = true,
--
--		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
--		-- Using this option may slow down your editor, and you may see some duplicate highlights.
--		-- Instead of true it can also be a list of languages
--		additional_vim_regex_highlighting = false,
--	},
--
--	incremental_selection = {
--		enable = true,
--		keymaps = {
--			init_selection = "gnn",
--			node_incremental = "grn",
--			scope_incremental = "grc",
--			node_decremental = "grm",
--			},
--		},
--	}
