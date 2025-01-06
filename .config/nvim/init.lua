-- ~/.config/nvim/init.lua

-- Packer initialization
require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'         -- LSP support
  use 'ray-x/go.nvim'                 -- Go development plugin
  use {
    'nvim-treesitter/nvim-treesitter', -- Treesitter for better syntax highlighting
    run = ':TSUpdate'
  }
  use 'hrsh7th/nvim-cmp'              -- Autocompletion
  use 'hrsh7th/cmp-nvim-lsp'          -- LSP completion
  use 'nvim-telescope/telescope.nvim' -- Fuzzy finder
  use 'vim-test/vim-test'             -- Running tests
  use 'tpope/vim-fugitive'            -- Git integration
  use 'Raimondi/delimitMate'          -- auto-close braces etc
  use 'pocco81/dap-buddy.nvim'        -- DAP installer
  use 'mfussenegger/nvim-dap'         -- Debug Adapter Protocol
  use 'nvim-neotest/nvim-nio'
  use {
    'rcarriga/nvim-dap-ui',           -- UI for DAP
    config = function()
      require("dapui").setup()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
      vim.keymap.set('n', '<leader>ui', require 'dapui'.toggle)
    end,
    requires = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    }
  }
  use {
    'microsoft/vscode-js-debug',
    opt = true,
    run = 'npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out' 
  }
  use {
    'mxsdev/nvim-dap-vscode-js',     -- Debug Adapter Protocol for JavaScript
    config = function()
      require('dap-vscode-js').setup({
        debugger_path = vim.fn.stdpath('data') .. "/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
        adapters = { 'chrome', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost', 'node', 'chrome' }, -- adapters to register in nvim-dap
      })
    end,
  }
  use 'github/copilot.vim'
  use {
    'olimorris/codecompanion.nvim',
    config = function()
      require('codecompanion').setup()
    end,
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    }
  }
end)

-- Colorscheme: Set xoria256 as the default
vim.cmd[[colorscheme xoria256]]

-- Enable relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable code folding by indentation and set it folded by default
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevelstart = 0

-- Indent settings
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Change split behavior: open vertical splits to the right and horizontal splits to the bottom
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.diffopt:append('vertical')

-- Treesitter configuration
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "go", "typescript", "tsx" },
  highlight = {
    enable = true,
  },
}

-- Diagnostic settings for LSP (global for all languages)
vim.diagnostic.config({
  virtual_text = true,  -- Show virtual text (inline error messages)
  signs = true,         -- Show signs in the gutter
  update_in_insert = false,  -- Don't show errors while typing
  underline = true,     -- Underline issues in the code
  severity_sort = true, -- Sort diagnostics by severity (Errors, Warnings, etc.)
})

-- Show diagnostics in a floating window on hover
vim.o.updatetime = 250  -- Set a shorter update time for diagnostics hover
-- Function to show diagnostics in a floating window
function _G.show_diagnostics()
  local opts = {
    focusable = false,
    close_events = {"BufLeave", "CursorMoved", "InsertEnter", "FocusLost"},
    border = 'rounded',
    source = 'always',
    prefix = '',
    scope = 'cursor',
  }
  vim.diagnostic.open_float(nil, opts)
end

-- Set up an autocmd for CursorHold to show diagnostics
vim.cmd([[
  augroup ShowDiagnostics
    autocmd!
    autocmd CursorHold * lua show_diagnostics()
  augroup END
]])

vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#bebebe', fg = '#dcdcdc' })

-- LSP setup for Go
require('lspconfig').gopls.setup{
  on_attach = function(_, bufnr)
    local opts = { noremap=true, silent=true }
    -- Key mappings for LSP
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)  -- Go to definition
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-\\|>', '<cmd>lua vim.lsp.buf.references()<CR>', opts)  -- Go to references
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)  -- Hover documentation

    -- Diagnostics key mappings
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)  -- Go to previous diagnostic
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)  -- Go to next diagnostic
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)  -- Show diagnostics in a floating window
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)  -- Add diagnostics to the location list
  end,
}

-- LSP setup for TypeScript
require('lspconfig').ts_ls.setup{
  on_attach = function(_, bufnr)
    local opts = { noremap=true, silent=true }
    -- Key mappings for LSP
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)  -- Go to definition
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-\\|>', '<cmd>lua vim.lsp.buf.references()<CR>', opts)  -- Go to references
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)  -- Hover documentation

    -- Diagnostics key mappings
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)  -- Go to previous diagnostic
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)  -- Go to next diagnostic
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)  -- Show diagnostics in a floating window
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)  -- Add diagnostics to the location list
  end,
}

--LSP setup for c# .net
local lspconfig = require('lspconfig')
lspconfig.omnisharp.setup({
  cmd = { "dotnet", "/home/hammad/omnisharp/OmniSharp.dll" },
  root_dir = lspconfig.util.root_pattern("*.csproj", ".git"),
  on_attach = function(_, bufnr)
    local opts = { noremap=true, silent=true }
    -- Key mappings for LSP
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)  -- Go to definition
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-\\|>', '<cmd>lua vim.lsp.buf.references()<CR>', opts)  -- Go to references
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)  -- Hover documentation

    -- Diagnostics key mappings
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)  -- Go to previous diagnostic
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)  -- Go to next diagnostic
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)  -- Show diagnostics in a floating window
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)  -- Add diagnostics to the location list
  end,
})

-- Autocompletion setup
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  })
})

-- Keymaps for Telescope (fuzzy finder)
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })

-- Test keymaps
vim.api.nvim_set_keymap('n', '<leader>t', ':TestNearest<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>T', ':TestFile<CR>', { noremap = true, silent = true })

-- Autocommand for auto-formatting on save (for Go and TypeScript)
vim.api.nvim_exec([[
  autocmd BufWritePre *.go,*.ts,*.tsx :silent! lua vim.lsp.buf.format()
]], false)

-- Vim-Fugitive keybindings for common Git commands
vim.api.nvim_set_keymap('n', '<leader>gs', ':Git<CR>', { noremap = true, silent = true })  -- Git status
vim.api.nvim_set_keymap('n', '<leader>gc', ':Git commit<CR>', { noremap = true, silent = true })  -- Git commit
vim.api.nvim_set_keymap('n', '<leader>gp', ':Git push<CR>', { noremap = true, silent = true })  -- Git push
vim.api.nvim_set_keymap('n', '<leader>gl', ':Git pull<CR>', { noremap = true, silent = true })  -- Git pull

-- Copilot keybindings
vim.api.nvim_set_keymap('i', '<Right>', 'copilot#Accept("")', { expr = true, replace_keycodes = false })
vim.g.copilot_no_tab_map = true

-- DAP keybindings
vim.keymap.set('n', '<F5>', require 'dap'.continue)
vim.keymap.set('n', '<F10>', require 'dap'.step_over)
vim.keymap.set('n', '<F11>', require 'dap'.step_into)
vim.keymap.set('n', '<F12>', require 'dap'.step_out)
vim.keymap.set('n', '<leader>b', require 'dap'.toggle_breakpoint)

-- DAP adapter configurations
local js_based_languages = { "typescript", "javascript", "typescriptreact" }

for _, language in ipairs(js_based_languages) do
  require("dap").configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require 'dap.utils'.pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Start Chrome with \"localhost\"",
      url = "http://localhost:3000",
      webRoot = "${workspaceFolder}",
      userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
    }
  }
end

