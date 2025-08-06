-- plugin manager 📦
-- https://github.com/echasnovski/mini.deps?tab=readme-ov-file#installation
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.deps'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.deps`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.deps', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.deps | helptags ALL')
  vim.cmd('echo "Installed `mini.deps`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })

-- general options 🪛
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
vim.opt.listchars:append({ trail = '⋅', precedes = '<', extends = '>' })
vim.opt.wrap = false
vim.opt.sidescrolloff = 6

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.undofile = true

-- plugins 🔌
local add = MiniDeps.add

add({
  source = 'zenbones-theme/zenbones.nvim',
  depends = { 'rktjmp/lush.nvim' },
})
vim.g.tokyobones_transparent_background = true
vim.cmd.colorscheme('tokyobones')

add({
  source = 'nvim-treesitter/nvim-treesitter',
  checkout = 'main',
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})
require('nvim-treesitter').install({
  'dockerfile',
  'gitignore',
  'javascript',
  'markdown',
  'typescript',
})
-- copied from https://erock-git-dotfiles.pgs.sh/tree/main/item/dot_config/nvim/init.lua.html#184
vim.api.nvim_create_autocmd('FileType', {
  callback = function(args)
    local filetype = args.match
    local lang = vim.treesitter.language.get_lang(filetype)
    if vim.treesitter.language.add(lang) then
      if vim.treesitter.query.get(filetype, 'indents') then
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
      vim.treesitter.start()
    end
  end,
})

add({ source = 'ibhagwan/fzf-lua' })
require('fzf-lua').setup({
  defaults = {
    formatter = 'path.filename_first',
  },
  grep = {
    RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH,
  },
  fzf_colors = true,
  winopts = {
    border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    preview = {
      border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    },
  },
  hls = { preview_border = 'CursorLine', preview_normal = 'CursorLine' },
})
vim.keymap.set('n', '<C-\\>', '<cmd>FzfLua buffers<cr>')
vim.keymap.set('n', '<C-p>', '<cmd>FzfLua files<cr>')
vim.keymap.set('n', '<C-g>', '<cmd>FzfLua live_grep resume=true<cr>')

add({ source = 'stevearc/oil.nvim' })
require('oil').setup({
  watch_for_changes = true,
  view_options = { show_hidden = true },
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
require("gitlinker").setup()
vim.keymap.set({ 'n', 'v' }, '<leader>gy', '<cmd>GitLink<cr>')
vim.keymap.set({ 'n', 'v' }, '<leader>gY', '<cmd>GitLink!<cr>')
