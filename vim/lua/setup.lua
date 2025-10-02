-- ================ LSP ======================

vim.lsp.enable('gopls')
vim.lsp.enable('nixd')
vim.lsp.enable('pylsp')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('terraformls')

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
vim.lsp.enable('yamlls')

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
