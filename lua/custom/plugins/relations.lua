-- File relationships, two layers:
--   1. other.nvim: jump between files related by naming convention
--      (component <-> test <-> styles <-> stories, Go/Python/Rust tests, ...)
--   2. Trouble LSP panel: how the symbol under the cursor connects to other files
--      (definitions, references, implementations, incoming/outgoing calls), grouped by file with line numbers
--
--   <leader>ro  open related file (picker if several)    <leader>rv  ... in a vertical split
--   <leader>rt  related test   <leader>rs  related styles   <leader>rc  related source (from a test)
--   <leader>rr  LSP relations panel for the symbol under the cursor
--   <leader>ri  who calls this (incoming)   <leader>rO  what this calls (outgoing)
--   <leader>rf  symbol outline of the current file
local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'rgroli/other.nvim' }

-- JS/TS source file -> its test, styles and stories living next to it
local js_source = '/(.*)/([^/.]+)%.([jt]sx?)$'

require('other-nvim').setup {
  mappings = {
    -- builtin convention sets (JS/TS is covered by the custom mappings below)
    'python',
    'golang',
    'rust',

    -- JS/TS: source -> neighbours
    { pattern = js_source, target = '/%1/%2.test.%3', context = 'test' },
    { pattern = js_source, target = '/%1/%2.spec.%3', context = 'test' },
    { pattern = js_source, target = '/%1/__tests__/%2.test.%3', context = 'test' },
    { pattern = js_source, target = '/%1/%2.module.css', context = 'style' },
    { pattern = js_source, target = '/%1/%2.css', context = 'style' },
    { pattern = js_source, target = '/%1/%2.scss', context = 'style' },
    { pattern = js_source, target = '/%1/%2.stories.%3', context = 'story' },

    -- JS/TS: test/spec/story -> source
    { pattern = '/(.*)/([^/.]+)%.test%.([jt]sx?)$', target = '/%1/%2.%3', context = 'source' },
    { pattern = '/(.*)/([^/.]+)%.spec%.([jt]sx?)$', target = '/%1/%2.%3', context = 'source' },
    { pattern = '/(.*)/__tests__/([^/.]+)%.test%.([jt]sx?)$', target = '/%1/%2.%3', context = 'source' },
    { pattern = '/(.*)/([^/.]+)%.stories%.([jt]sx?)$', target = '/%1/%2.%3', context = 'source' },

    -- styles -> component
    { pattern = '/(.*)/([^/.]+)%.module%.css$', target = '/%1/%2.tsx', context = 'source' },
    { pattern = '/(.*)/([^/.]+)%.s?css$', target = '/%1/%2.tsx', context = 'source' },
  },
  -- only offer files that actually exist
  showMissingFiles = false,
  style = { border = 'rounded', width = 0.6 },
}

require('which-key').add { { '<leader>r', group = '[R]elated files' } }

vim.keymap.set('n', '<leader>ro', '<cmd>Other<CR>', { desc = '[R]elated: [o]pen' })
vim.keymap.set('n', '<leader>rv', '<cmd>OtherVSplit<CR>', { desc = '[R]elated: open in [v]split' })
vim.keymap.set('n', '<leader>rt', '<cmd>Other test<CR>', { desc = '[R]elated: [t]est' })
vim.keymap.set('n', '<leader>rs', '<cmd>Other style<CR>', { desc = '[R]elated: [s]tyles' })
vim.keymap.set('n', '<leader>rc', '<cmd>Other source<CR>', { desc = '[R]elated: [c]ode/source' })

-- Trouble modes (trouble.nvim is set up in trouble.lua)
vim.keymap.set('n', '<leader>rr', '<cmd>Trouble lsp toggle focus=false win.position=right<CR>', { desc = '[R]elated: LSP [r]elations panel' })
vim.keymap.set('n', '<leader>ri', '<cmd>Trouble lsp_incoming_calls toggle<CR>', { desc = '[R]elated: [i]ncoming calls' })
vim.keymap.set('n', '<leader>rO', '<cmd>Trouble lsp_outgoing_calls toggle<CR>', { desc = '[R]elated: [O]utgoing calls' })
vim.keymap.set('n', '<leader>rf', '<cmd>Trouble symbols toggle focus=false win.position=left<CR>', { desc = '[R]elated: [f]ile outline' })
