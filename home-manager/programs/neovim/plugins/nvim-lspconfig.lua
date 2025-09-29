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

-- Terraform Language Server
vim.lsp.config('terraformls', {
  cmd = { 'terraform-ls', 'serve' },
  root_markers = { '.terraform', '*.tf', '.git' },
  filetypes = { 'terraform', 'tf' }
})

-- TypeScript Language Server
vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' }
})

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

-- Nix Language Server (nixd)
vim.lsp.config('nixd', {
  cmd = { 'nixd' },
  root_markers = { 'flake.nix', 'default.nix', 'shell.nix', '.git' },
  filetypes = { 'nix' }
})

-- Auto-start LSP clients for configured servers
local function start_lsp_for_filetype(filetype)
  local server_map = {
    dart = 'dartls',
    terraform = 'terraformls',
    tf = 'terraformls',
    typescript = 'ts_ls',
    typescriptreact = 'ts_ls',
    javascript = 'ts_ls',
    javascriptreact = 'ts_ls',
    yaml = 'yamlls',
    yml = 'yamlls',
    nix = 'nixd'
  }

  local server_name = server_map[filetype]
  if server_name then
    vim.lsp.start({ name = server_name })
  end
end

vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local bufnr = args.buf
    local filetype = vim.bo[bufnr].filetype

    -- Only start LSP if no client is already attached to this buffer
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    if #clients == 0 then
      start_lsp_for_filetype(filetype)
    end
  end
})
