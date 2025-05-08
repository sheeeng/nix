require("lspconfig").dartls.setup({})
require("lspconfig").terraformls.setup({})
require("lspconfig").ts_ls.setup({})
require("lspconfig").yamlls.setup({})
require("lspconfig").nixd.setup({})

require("lspconfig").lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
}) -- https://neovim.discourse.group/t/how-to-suppress-warning-undefined-global-vim/1882/16
