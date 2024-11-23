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

vim.opt.updatetime = 250

vim.opt.swapfile = false
vim.opt.undofile = true

vim.diagnostic.config({
  float = {
    source = 'always',
    border = 'rounded',
    header = '',
    focusable = false,
  },
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Center cursor on half-page up/down
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>')

vim.keymap.set('n', 'gl', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_next)
vim.keymap.set('n', ']d', vim.diagnostic.goto_prev)

local toggle_diagnostics = function()
  local enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enabled)
end

vim.keymap.set('n', '<leader>ud', toggle_diagnostics)

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
      'rose-pine/neovim',
      name = 'rose-pine',
      config = function()
        require('rose-pine').setup({
          styles = {
            italic = false,
            transparency = true,
          },
        })
        vim.cmd('colorscheme rose-pine')
      end,
    },
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
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
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set('n', '<leader>f', '<cmd>lua vim.lsp.buf.format({ async = true })<cr>', opts)
          end,
        })

        local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
        local capabilities = vim.tbl_deep_extend(
          'force',
          {},
          vim.lsp.protocol.make_client_capabilities(),
          has_cmp and cmp_nvim_lsp.default_capabilities() or {}
        )
        local handlers = {
          ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
          ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
        }

        require('mason').setup()

        require('mason-lspconfig').setup({
          ensure_installed = { 'ts_ls', 'biome', 'eslint' },
          handlers = {
            function(server_name)
              require('lspconfig')[server_name].setup({
                capabilities = capabilities,
                handlers = handlers,
              })
            end,
          },
        })
      end,
    },
    {
      'williamboman/mason.nvim',
      config = function()
        require('mason').setup()
        -- https://github.com/LazyVim/LazyVim/blob/a1c3ec4cd43fe61e3b614237a46ac92771191c81/lua/lazyvim/plugins/lsp/init.lua#L289-L296
        local masonRegistry = require('mason-registry')

        masonRegistry.refresh(function()
          for _, tool in ipairs({ 'stylua', 'prettier' }) do
            local pkg = masonRegistry.get_package(tool)
            if not pkg:is_installed() then
              pkg:install()
            end
          end
        end)
      end,
    },
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
      },
      config = function()
        local cmp = require('cmp')

        cmp.setup({
          snippet = {
            expand = function(args)
              vim.snippet.expand(args.body)
            end,
          },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
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
      end,
    },
    {
      'nvimtools/none-ls.nvim',
      dependencies = { 'williamboman/mason.nvim' },
      config = function()
        local null_ls = require('null-ls')
        null_ls.setup({
          sources = {
            null_ls.builtins.formatting.stylua,
            null_ls.builtins.formatting.prettier,
          },
        })
      end,
    },
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
      config = function()
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
      end,
    },
    {
      'nvim-telescope/telescope.nvim',
      dependencies = {
        'nvim-treesitter/nvim-treesitter',
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          build = 'make',
          enabled = vim.fn.executable('make') == 1,
        },
      },
      config = function()
        pcall(require('telescope').load_extension, 'fzf')
        local actions = require('telescope.actions')

        require('telescope').setup({
          defaults = {
            mappings = {
              n = { ['q'] = actions.close },
            },
          },
          pickers = {
            buffers = {
              initial_mode = 'normal',
              mappings = {
                n = { ['d'] = actions.delete_buffer },
              },
            },
            live_grep = {
              mappings = {
                i = { ['<C-f>'] = actions.to_fuzzy_refine },
              },
            },
          },
        })

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files)
        vim.keymap.set('n', '<leader>fg', builtin.live_grep)
        vim.keymap.set('n', '<leader>fb', function()
          builtin.buffers({ sort_mru = true })
        end)
      end,
    },
    {
      'echasnovski/mini.files',
      version = '*',
      config = function()
        require('mini.files').setup()
        -- https://github.com/LazyVim/LazyVim/blob/a1c3ec4cd43fe61e3b614237a46ac92771191c81/lua/lazyvim/plugins/extras/editor/mini-files.lua#L16-L22
        vim.keymap.set('n', '<leader>fm', function()
          require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
        end)
      end,
    },
    {
      'mrjones2014/smart-splits.nvim',
      config = function()
        local smart_splits = require('smart-splits')

        vim.keymap.set('n', '<A-h>', smart_splits.resize_left)
        vim.keymap.set('n', '<A-j>', smart_splits.resize_down)
        vim.keymap.set('n', '<A-k>', smart_splits.resize_up)
        vim.keymap.set('n', '<A-l>', smart_splits.resize_right)

        vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left)
        vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down)
        vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up)
        vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right)
      end,
    },
    -- Build good vim habits
    {
      'm4xshen/hardtime.nvim',
      dependencies = { 'MunifTanjim/nui.nvim' },
      opts = { disable_mouse = false },
    },
    'ThePrimeagen/vim-be-good',
    'github/copilot.vim',
  },
  rocks = { enabled = false },
})
