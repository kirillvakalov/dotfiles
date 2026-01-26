-- Plugin manager 📦
-- https://github.com/nvim-mini/mini.deps?tab=readme-ov-file#installation
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.deps'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.deps`" | redraw')
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/nvim-mini/mini.deps',
    mini_path,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.deps | helptags ALL')
  vim.cmd('echo "Installed `mini.deps`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })

-- General options 🪛
-- https://neovim.io/doc/user/options.html
vim.g.mapleader = ' '

vim.opt.clipboard = 'unnamedplus'
vim.opt.mouse = 'a'

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'

vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'

-- https://neovim.io/doc/user/usr_30.html#_tabs-and-spaces
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Indent size
vim.opt.softtabstop = 2
vim.opt.smartindent = true

vim.opt.ignorecase = true -- Ignore case in search
vim.opt.smartcase = true -- Don't ignore case with uppercase chars

vim.opt.list = true -- Show invisible chars (tabs, trailing spaces, etc...)
vim.opt.listchars:append({ trail = '⋅', extends = '…' })
vim.opt.wrap = false
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 6

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.undofile = true

vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 10 -- Fold nothing by default
vim.opt.foldnestmax = 10 -- Limit number of fold levels

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
})

-- Center cursor on half-page up/down
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>')

-- Toggle diagnostics
vim.keymap.set('n', '<leader>td', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end)
-- Toggle relative numbers
vim.keymap.set('n', '<leader>tr', function() vim.opt.relativenumber = not vim.opt.relativenumber:get() end)

-- Plugins 🔌
local add = MiniDeps.add

add({ source = 'sainnhe/edge' })
vim.cmd.colorscheme('edge')

add({
  source = 'nvim-treesitter/nvim-treesitter',
  checkout = 'main',
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})
-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
require('nvim-treesitter').install({
  'dockerfile',
  'gitignore',
  'javascript',
  'json',
  'jsx',
  'markdown',
  'sql',
  'terraform',
  'tsx',
  'typescript',
  'yaml',
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'dockerfile',
    'gitignore',
    'javascript',
    'json',
    'javascriptreact',
    'markdown',
    'sql',
    'terraform',
    'typescriptreact',
    'typescript',
    'yaml',
  },
  callback = function(args)
    -- Do not enable slow treesitter highlights for files larger than 100KB
    local max_filesize = 100 * 1024
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > max_filesize then return end

    -- Enable highlights
    vim.treesitter.start()
    -- Enable indentation
    if vim.treesitter.query.get(args.match, 'indents') then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

add({ source = 'mason-org/mason.nvim' })
require('mason').setup()
local masonRegistry = require('mason-registry')
local tools = {
  'vtsls',
  'eslint-lsp',
  'biome',
  'prettier',
  'sqlfluff',
  'stylua',
}
masonRegistry.refresh(function()
  for _, tool in ipairs(tools) do
    local pkg = masonRegistry.get_package(tool)
    if not pkg:is_installed() then pkg:install() end
  end
end)

add({ source = 'neovim/nvim-lspconfig' })
vim.lsp.config('vtsls', {
  settings = {
    vtsls = {
      experimental = {
        completion = { enableServerSideFuzzyMatch = true, entriesLimit = 1000 },
      },
    },
  },
})
-- Fix for warning from :checkhealth vim.lsp
-- ⚠️ WARNING Found buffers attached to multiple clients with different position encodings.
vim.lsp.config('biome', {
  capabilities = {
    general = { positionEncodings = { 'utf-16' } },
  },
})
vim.lsp.enable({ 'vtsls', 'eslint', 'biome' })

add({
  source = 'saghen/blink.cmp',
  checkout = 'v1.8.0',
})
require('blink.cmp').setup({
  keymap = { preset = 'default' },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  completion = {
    accept = { auto_brackets = { enabled = false } },
  },
})
-- Remove this once https://github.com/Saghen/blink.cmp/pull/487 is merged (in v2 version)
-- and use ['<C-x><C-o>'] = { 'show', 'show_documentation', 'hide_documentation' }
-- in blink keymap settings
vim.keymap.set('i', '<C-x><C-o>', function()
  local blink = require('blink.cmp')
  blink.show()
  blink.show_documentation()
  blink.hide_documentation()
end)

add({ source = 'stevearc/conform.nvim' })
require('conform').setup({
  -- copied from
  -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/formatting/prettier.lua
  formatters_by_ft = {
    css = { 'prettier' },
    graphql = { 'prettier' },
    handlebars = { 'prettier' },
    html = { 'prettier' },
    javascript = { 'prettier' },
    javascriptreact = { 'prettier' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    less = { 'prettier' },
    markdown = { 'prettier' },
    ['markdown.mdx'] = { 'prettier' },
    scss = { 'prettier' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    vue = { 'prettier' },
    yaml = { 'prettier' },
    lua = { 'stylua' },
  },
  default_format_opts = {
    lsp_format = 'fallback',
  },
})
vim.keymap.set('n', '<leader>f', function() require('conform').format({ async = true }) end)

-- We have to use none-ls for sqlfluff because it fails to format with
-- conform.nvim if SQL file has lint errors
add({
  source = 'nvimtools/none-ls.nvim',
  depends = { 'nvim-lua/plenary.nvim' },
})
local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.sqlfluff,
    null_ls.builtins.diagnostics.sqlfluff,
  },
})

add({ source = 'nvim-mini/mini.pick' })
add({ source = 'wsdjeg/bufdel.nvim' })
-- Disable file icons
local pick = require('mini.pick')
pick.setup({ source = { show = pick.default_show } })
-- Buffers picker that shows modified buffers with `+` prefix
-- and has <C-d> mapping to delete current buffer.
-- Based on builtin buffers picker:
-- https://github.com/nvim-mini/mini.nvim/blob/3ced440/lua/mini/pick.lua#L1511-L1528
MiniPick.registry.buffers_custom = function()
  local get_items = function()
    local buffers_output = vim.api.nvim_exec('buffers', true)
    local items = {}
    for _, l in ipairs(vim.split(buffers_output, '\n')) do
      local buf_str, name = l:match('^%s*%d+'), l:match('"(.*)"')
      local buf_id = tonumber(buf_str)
      local prefix = vim.bo[buf_id].modified and '+ ' or '  '
      local item = { text = prefix .. name, bufnr = buf_id }
      table.insert(items, item)
    end
    return items
  end

  -- Using bufdel dependency instead of nvim api to be able to delete current
  -- (last) buffer easily, as it handles all cases correctly (e.g. creating
  -- empty buffer and switching to it when deleting last buffer)
  local buf_delete = function()
    require('bufdel').delete(MiniPick.get_picker_matches().current.bufnr)
    MiniPick.set_picker_items(get_items())
  end

  return MiniPick.start({
    source = { items = get_items(), name = 'Buffers' },
    mappings = { delete_buffer = { char = '<C-d>', func = buf_delete } },
  })
end
vim.keymap.set('n', '<C-p>', MiniPick.builtin.files)
vim.keymap.set('n', '<leader>b', MiniPick.registry.buffers_custom)
vim.keymap.set('n', '<leader>/', MiniPick.builtin.grep_live)
vim.keymap.set('n', "<leader>'", MiniPick.builtin.resume)

add({ source = 'stevearc/oil.nvim' })
require('oil').setup({
  watch_for_changes = true,
  view_options = { show_hidden = true },
  keymaps = {
    -- We use these keymaps to navigate between windows with smart-splits
    ['<C-h>'] = false,
    ['<C-l>'] = false,
    -- We use this keymap for MiniPick files
    ['<C-p>'] = false,
    -- Same keymaps as <C-w> splits
    ['<C-s>'] = { 'actions.select', opts = { horizontal = true } },
    ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
  },
})
vim.keymap.set('n', '-', '<cmd>Oil<cr>')

add({ source = 'mrjones2014/smart-splits.nvim' })
local smart_splits = require('smart-splits')
vim.keymap.set('n', '<M-Left>', smart_splits.resize_left)
vim.keymap.set('n', '<M-Down>', smart_splits.resize_down)
vim.keymap.set('n', '<M-Up>', smart_splits.resize_up)
vim.keymap.set('n', '<M-Right>', smart_splits.resize_right)
vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left)
vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down)
vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up)
vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right)

add({ source = 'rmagatti/auto-session' })
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
require('auto-session').setup()

add({ source = 'linrongbin16/gitlinker.nvim' })
require('gitlinker').setup()
vim.keymap.set({ 'n', 'v' }, '<leader>gy', '<cmd>GitLink<cr>')
vim.keymap.set({ 'n', 'v' }, '<leader>gY', '<cmd>GitLink!<cr>')

add({
  source = 'ThePrimeagen/harpoon',
  checkout = 'harpoon2',
  depends = { 'nvim-lua/plenary.nvim' },
})
local harpoon = require('harpoon')
harpoon:setup()
vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end)
vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end)
vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end)
vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end)
vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end)
