vim.g.mapleader = ' '

-- https://neovim.io/doc/user/options.html
vim.opt.clipboard = 'unnamedplus'

vim.opt.list = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.scrolloff = 4

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.updatetime = 250

vim.opt.swapfile = false
vim.opt.undofile = true

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- https://lazy.folke.io/installation
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/nvim-cmp',
    'nvim-lua/plenary.nvim',
    'nvimtools/none-ls.nvim',
  },
  rocks = { enabled = false },
})

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
  end,
})

local capabilities = vim.tbl_deep_extend(
  'force',
  {},
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'ts_ls' },
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({
        capabilities = capabilities,
      })
    end,
  },
})

local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v4.x/lua/lsp-zero/cmp-mapping.lua#L28-L41
    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1
      if cmp.visible() then
        cmp.select_next_item()
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
})

-- https://github.com/williamboman/mason-lspconfig.nvim/issues/113#issuecomment-1471346816
for _, pkg_name in ipairs({ 'stylua', 'prettier', 'biome' }) do
  local ok, pkg = pcall(require('mason-registry').get_package, pkg_name)
  if ok then
    if not pkg:is_installed() then
      pkg:install()
    end
  end
end

local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.biome,
  },
})
