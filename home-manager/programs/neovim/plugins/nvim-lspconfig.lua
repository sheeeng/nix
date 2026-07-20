-- Migrated from deprecated require('lspconfig') to vim.lsp.config API
-- See :help lspconfig-nvim-0.11 for more information

-- The `require('lspconfig')` "framework" is deprecated, use vim.lsp.config (see :help lspconfig-nvim-0.11) instead.
-- Feature will be removed in nvim-lspconfig v3.0.0

-- Dart Language Server
vim.lsp.config('dartls', {
  cmd = { 'dart', 'language-server', '--protocol=lsp' },
  root_markers = { 'pubspec.yaml', '.git' },
  filetypes = { 'dart' }
})
vim.lsp.enable('dartls')

-- Terraform Language Server
vim.lsp.config('terraformls', {
  cmd = { 'terraform-ls', 'serve' },
  root_markers = { '.terraform', '*.tf', '.git' },
  filetypes = { 'terraform', 'tf' }
})
vim.lsp.enable('terraformls')

-- TypeScript Language Server
vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' }
})
vim.lsp.enable('ts_ls')

-- YAML Language Server
vim.lsp.config('yamlls', {
  cmd = { 'yaml-language-server', '--stdio' },
  root_markers = { '.git' },
  filetypes = { 'yaml', 'yml' },
  settings = {
    yaml = {
      schemas = {
        ['https://json.schemastore.org/github-workflow.json'] = '/.github/workflows/*',
        ['https://json.schemastore.org/kustomization.json'] = 'kustomization.yaml',
        ['https://json.schemastore.org/chart.json'] = 'Chart.yaml'
      }
    }
  }
})
vim.lsp.enable('yamlls')

-- Nix Language Server (nixd)
vim.lsp.config('nixd', {
  cmd = { 'nixd' },
  root_markers = { 'flake.nix', 'default.nix', 'shell.nix', '.git' },
  filetypes = { 'nix' }
})
vim.lsp.enable('nixd')
