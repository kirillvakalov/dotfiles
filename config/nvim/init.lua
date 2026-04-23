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

-- Toggle diagnostics
vim.keymap.set('n', '<leader>td', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end)
-- Toggle relative numbers
vim.keymap.set('n', '<leader>tr', function() vim.opt.relativenumber = not vim.opt.relativenumber:get() end)

-- Plugins 🔌
-- Built-in plugins
-- Clear highlights on search after 4 seconds of idle time, when pressing <Esc>
-- in normal mode or entering Insert mode.
vim.cmd('packadd nohlsearch')
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>')

vim.cmd('packadd nvim.undotree')
vim.keymap.set('n', '<leader>u', require('undotree').open)

-- Third-party plugins
-- 💡 vim.pack hints:
--   Update all     :lua vim.pack.update()
--   Delete plugin  :lua vim.pack.del({ 'plugin-name' })
--   List installed
--     :lua for _, p in ipairs(vim.pack.get()) do print(p.spec.name) end

-- Update treesitter parsers when nvim-treesitter plugin is updated
-- ref: https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack.html#hooks
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end,
})

vim.pack.add({
  'https://github.com/sainnhe/edge',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  { src = 'https://github.com/saghen/blink.cmp', version = 'v1.10.2' },
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvimtools/none-ls.nvim',
  'https://github.com/nvim-mini/mini.pick',
  'https://github.com/nvim-mini/mini.bufremove',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/mrjones2014/smart-splits.nvim',
  'https://github.com/rmagatti/auto-session',
  { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' },
})

vim.cmd.colorscheme('edge')

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
    -- Do not enable treesitter highlights for files larger than 100KB, as they
    -- are quite slow
    local max_filesize = 100 * 1024
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    if ok and stats and stats.size > max_filesize then return end

    vim.treesitter.start()
  end,
})

require('mason').setup()
local masonRegistry = require('mason-registry')
local tools = {
  'tsgo',
  'oxlint',
  'oxfmt',
  'sqlfluff',
  'stylua',
}
masonRegistry.refresh(function()
  for _, tool in ipairs(tools) do
    local pkg = masonRegistry.get_package(tool)
    if not pkg:is_installed() then pkg:install() end
  end
end)

vim.lsp.enable({ 'tsgo', 'oxlint' })

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

require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    -- https://oxc.rs/docs/guide/usage/formatter.html#supported-languages
    javascript = { 'oxfmt' },
    javascriptreact = { 'oxfmt' },
    typescript = { 'oxfmt' },
    typescriptreact = { 'oxfmt' },
    json = { 'oxfmt' },
    jsonc = { 'oxfmt' },
    json5 = { 'oxfmt' },
    yaml = { 'oxfmt' },
    toml = { 'oxfmt' },
    html = { 'oxfmt' },
    css = { 'oxfmt' },
    markdown = { 'oxfmt' },
    ['markdown.mdx'] = { 'oxfmt' },
    graphql = { 'oxfmt' },
    handlebars = { 'oxfmt' },
  },
  default_format_opts = {
    lsp_format = 'fallback',
  },
})
vim.keymap.set('n', '<leader>f', function() require('conform').format({ async = true }) end)

-- We have to use none-ls for sqlfluff because it fails to format with
-- conform.nvim if SQL file has lint errors
local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.sqlfluff,
    null_ls.builtins.diagnostics.sqlfluff,
  },
})

local pick = require('mini.pick')
pick.setup({
  -- Disable file icons
  source = { show = pick.default_show },
  mappings = {
    refine = '<M-Space>',
    refine_marked = '<M-S-Space>',
  },
})
-- Buffers picker that shows modified buffers with `+` prefix and has <C-d>
-- mapping to delete current buffer.
-- Based on builtin buffers picker:
-- https://github.com/nvim-mini/mini.nvim/blob/3ced440/lua/mini/pick.lua#L1511-L1528
MiniPick.registry.buffers_custom = function()
  local get_items = function()
    local items = {}
    local buffers_output = vim.api.nvim_exec('buffers', true)
    if buffers_output == '' then return items end
    for _, l in ipairs(vim.split(buffers_output, '\n')) do
      local buf_str, name = l:match('^%s*%d+'), l:match('"(.*)"')
      local buf_id = tonumber(buf_str)
      local prefix = vim.bo[buf_id].modified and '+ ' or '  '
      local item = { text = prefix .. name, bufnr = buf_id }
      table.insert(items, item)
    end
    return items
  end
  -- Using mini.bufremove instead of nvim api to be able to delete any buffer
  -- easily, as it handles all cases correctly (e.g. creating empty buffer and
  -- switching to it when deleting last buffer)
  local buf_delete = function()
    local matches = MiniPick.get_picker_matches()
    if not matches or not matches.current then return end
    require('mini.bufremove').delete(matches.current.bufnr)
    -- Refresh list to stop showing deleted buffer and keep cursor at same
    -- position. set_picker_items always resets cursor to 1, so we restore it
    -- after via vim.schedule (set_picker_items processes items in a
    -- coroutine).
    local items = get_items()
    local ind = math.min(matches.current_ind, #items)
    MiniPick.set_picker_items(items)
    vim.schedule(function() MiniPick.set_picker_match_inds({ ind }, 'current') end)
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

local smart_splits = require('smart-splits')
vim.keymap.set('n', '<M-Left>', smart_splits.resize_left)
vim.keymap.set('n', '<M-Down>', smart_splits.resize_down)
vim.keymap.set('n', '<M-Up>', smart_splits.resize_up)
vim.keymap.set('n', '<M-Right>', smart_splits.resize_right)
vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left)
vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down)
vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up)
vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right)

vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
require('auto-session').setup()

local harpoon = require('harpoon')
harpoon:setup()
vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end)
vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end)
vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end)
vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end)
vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end)

