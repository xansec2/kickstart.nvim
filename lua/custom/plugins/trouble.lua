-- Trouble diagnostics list: <leader>xx
local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'folke/trouble.nvim' }
require('trouble').setup {}

require('which-key').add { { '<leader>x', group = 'Trouble' } }
vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', { desc = 'Trouble: workspace diagnostics' })
vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', { desc = 'Trouble: buffer diagnostics' })
