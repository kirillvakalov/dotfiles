-- https://github.com/nvim-lua/kickstart.nvim
-- https://github.com/NvChad/NvChad/tree/v2.5
-- https://github.com/LazyVim/LazyVim
-- https://github.com/AstroNvim/AstroNvim
-- https://github.com/LunarVim/LunarVim
-- https://github.com/jesseleite/dotfiles/tree/master/nvim
vim.g.mapleader = ' '

-- https://neovim.io/doc/user/options.html
vim.opt.clipboard = 'unnamedplus'
vim.opt.mouse = 'a'
vim.opt.laststatus = 3

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'

vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 6
vim.opt.sidescrolloff = 6
vim.opt.wrap = false

vim.opt.list = true
vim.opt.listchars:append({ trail = '⋅' })

vim.opt.pumheight = 10 -- maximum number of items in a popup

vim.opt.updatetime = 250 -- 🤷

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.swapfile = false
vim.opt.undofile = true

-- Recommended options by auto-session plugin
vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

vim.diagnostic.config({
  float = {
    source = 'always',
    header = '',
  },
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

-- Center cursor on half-page up/down
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>')

vim.keymap.set('n', 'gl', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_next)
vim.keymap.set('n', ']d', vim.diagnostic.goto_prev)

vim.keymap.set('n', '<leader>ud', function()
  local enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enabled)
end)
vim.keymap.set('n', '<leader>ur', function() vim.opt.relativenumber = not vim.opt.relativenumber:get() end)

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
    'nvim-lua/plenary.nvim',
    {
      'zenbones-theme/zenbones.nvim',
      dependencies = 'rktjmp/lush.nvim',
      config = function()
        vim.g.forestbones_transparent_background = true
        vim.cmd.colorscheme('forestbones')
      end,
    },
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        'saghen/blink.cmp',
        { 'mason-org/mason.nvim', version = '^1.0.0' },
        { 'mason-org/mason-lspconfig.nvim', version = '^1.0.0' },
      },
      config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
          desc = 'LSP actions',
          callback = function(event)
            -- https://neovim.io/doc/user/lsp.html#_lua-module:-vim.lsp.semantic_tokens
            -- https://github.com/NvChad/NvChad/blob/8d2bb359e47d816e67ff86b5ce2d8f5abfe2b631/lua/nvchad/configs/lspconfig.lua#L31-L36
            -- https://www.reddit.com/r/neovim/comments/zjqquc/comment/izwahv7/
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            client.server_capabilities.semanticTokensProvider = nil

            local opts = { buffer = event.buf }
            vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
          end,
        })

        require('mason').setup()
        require('mason-lspconfig').setup({
          ensure_installed = { 'vtsls', 'biome', 'eslint' },
        })

        local lspconfig = require('lspconfig')
        local capabilities = require('blink.cmp').get_lsp_capabilities()

        require('mason-lspconfig').setup_handlers({
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,
          -- https://github.com/Saghen/blink.cmp/issues/1115#issuecomment-2646476212
          ['vtsls'] = function()
            lspconfig.vtsls.setup({
              capabilities = capabilities,
              settings = {
                vtsls = {
                  experimental = {
                    completion = { enableServerSideFuzzyMatch = true, entriesLimit = 1000 },
                  },
                },
              },
            })
          end,
        })
      end,
    },
    {
      'mason-org/mason.nvim',
      config = function()
        require('mason').setup()
        -- https://github.com/LazyVim/LazyVim/blob/a1c3ec4cd43fe61e3b614237a46ac92771191c81/lua/lazyvim/plugins/lsp/init.lua#L289-L296
        local masonRegistry = require('mason-registry')

        masonRegistry.refresh(function()
          for _, tool in ipairs({ 'stylua', 'prettier', 'sqlfluff' }) do
            local pkg = masonRegistry.get_package(tool)
            if not pkg:is_installed() then pkg:install() end
          end
        end)
      end,
    },
    {
      'saghen/blink.cmp',
      version = '1.*',
      opts = {
        keymap = { preset = 'default' },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
      },
    },
    {
      'nvimtools/none-ls.nvim',
      dependencies = { { 'mason-org/mason.nvim' } },
      config = function()
        local null_ls = require('null-ls')
        null_ls.setup({
          sources = {
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.prettier,
            null_ls.builtins.formatting.sqlfluff.with({
              extra_args = { '--dialect', 'postgres' },
            }),
            null_ls.builtins.diagnostics.sqlfluff.with({
              extra_args = { '--dialect', 'postgres' },
            }),
          },
        })
      end,
    },
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup({
          auto_install = true,
          highlight = { enable = true },
          indent = { enable = true },
        })
      end,
    },
    {
      'ibhagwan/fzf-lua',
      config = function()
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
        vim.keymap.set('n', '<C-g>', '<cmd>FzfLua live_grep_resume<cr>')
      end,
    },
    {
      'stevearc/oil.nvim',
      lazy = false,
      config = function()
        require('oil').setup({
          watch_for_changes = true,
          view_options = { show_hidden = true },
        })

        vim.keymap.set('n', '-', '<cmd>Oil<cr>')
      end,
    },
    {
      'mrjones2014/smart-splits.nvim',
      config = function()
        local smart_splits = require('smart-splits')

        -- 🙅 Why Ctrl-Shift hjkl keybindings are interpreted like M-Arrow keys inside neovim?
        vim.keymap.set('n', '<M-Left>', function() smart_splits.resize_left(5) end)
        vim.keymap.set('n', '<M-Down>', function() smart_splits.resize_down(3) end)
        vim.keymap.set('n', '<M-Up>', function() smart_splits.resize_up(3) end)
        vim.keymap.set('n', '<M-Right>', function() smart_splits.resize_right(5) end)

        vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left)
        vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down)
        vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up)
        vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right)
      end,
    },
    {
      'rmagatti/auto-session',
      lazy = false,
      opts = {},
    },
    {
      'm4xshen/hardtime.nvim',
      dependencies = { 'MunifTanjim/nui.nvim' },
      opts = {
        disable_mouse = false,
        restricted_keys = {
          ['j'] = {},
          ['k'] = {},
        },
      },
    },
  },
})
