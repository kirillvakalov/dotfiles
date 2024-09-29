vim.g.mapleader = ' '

-- https://neovim.io/doc/user/options.html
vim.opt.clipboard = 'unnamedplus'

vim.opt.list = true
vim.opt.listchars:append({ trail = '⋅' })

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

-- Center cursor on half-page up/down
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>')

vim.keymap.set('n', '[d', vim.diagnostic.goto_next)
vim.keymap.set('n', ']d', vim.diagnostic.goto_prev)

vim.diagnostic.config({
  float = {
    source = 'always',
  },
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

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
    { 'rose-pine/neovim', name = 'rose-pine' },
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/nvim-cmp',
    'nvim-lua/plenary.nvim',
    'nvimtools/none-ls.nvim',
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    'nvim-treesitter/nvim-treesitter-textobjects',
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x' },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'echasnovski/mini.nvim', version = false },
    -- Build good vim habits
    { 'm4xshen/hardtime.nvim', dependencies = { 'MunifTanjim/nui.nvim' }, opts = {} },
    'ThePrimeagen/vim-be-good',
  },
  rocks = { enabled = false },
})

require('rose-pine').setup({
  styles = { italic = false },
})

vim.cmd('colorscheme rose-pine')

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    -- https://neovim.io/doc/user/lsp.html#_lua-module:-vim.lsp.semantic_tokens
    -- https://github.com/NvChad/NvChad/blob/8d2bb359e47d816e67ff86b5ce2d8f5abfe2b631/lua/nvchad/configs/lspconfig.lua#L31-L36
    -- https://www.reddit.com/r/neovim/comments/zjqquc/comment/izwahv7/
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil

    local opts = { buffer = event.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({ async = true })<cr>', opts)
  end,
})

local capabilities = vim.tbl_deep_extend(
  'force',
  {},
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)

require('mason').setup()

-- https://github.com/LazyVim/LazyVim/blob/a1c3ec4cd43fe61e3b614237a46ac92771191c81/lua/lazyvim/plugins/lsp/init.lua#L289-L296
local masonRegistry = require('mason-registry')

masonRegistry.refresh(function()
  for _, tool in ipairs({ 'stylua', 'prettier', 'biome' }) do
    local pkg = masonRegistry.get_package(tool)
    if not pkg:is_installed() then
      pkg:install()
    end
  end
end)

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

local null_ls = require('null-ls')

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.biome,
  },
})

require('nvim-treesitter.configs').setup({
  auto_install = true,
  highlight = { enable = true },
  indent = { enable = true },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
  },
})

require('telescope').setup()
require('telescope').load_extension('fzf')

local telescopeBuiltin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescopeBuiltin.find_files)
vim.keymap.set('n', '<leader>fg', telescopeBuiltin.live_grep)
vim.keymap.set('n', '<leader>fb', telescopeBuiltin.buffers)

require('mini.files').setup()
-- https://github.com/LazyVim/LazyVim/blob/a1c3ec4cd43fe61e3b614237a46ac92771191c81/lua/lazyvim/plugins/extras/editor/mini-files.lua#L16-L22
vim.keymap.set('n', '<leader>fm', function()
  require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
end)
