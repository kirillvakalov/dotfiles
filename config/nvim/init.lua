vim.g.mapleader = ' '

-- https://neovim.io/doc/user/options.html
vim.opt.clipboard = 'unnamedplus'

vim.opt.list = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.undodir = os.getenv('HOME') .. '/.local/state/nvim/undodir'
vim.opt.undofile = true
