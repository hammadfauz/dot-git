-- ~/.config/nvim/init.lua

-- Packer initialization
require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'         -- LSP support
  use 'ray-x/go.nvim'                 -- Go development plugin
  use 'nvim-treesitter/nvim-treesitter' -- Treesitter for better syntax highlighting
  use 'hrsh7th/nvim-cmp'              -- Autocompletion
  use 'hrsh7th/cmp-nvim-lsp'          -- LSP completion
  use 'nvim-telescope/telescope.nvim' -- Fuzzy finder
  use 'vim-test/vim-test'             -- Running tests
  use 'tpope/vim-fugitive'            -- Git integration
  use 'Raimondi/delimitMate'          -- auto-close braces etc
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
vim.api.nvim_create_autocmd("CursorHold", {
  buffer = 0,
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end
})
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

