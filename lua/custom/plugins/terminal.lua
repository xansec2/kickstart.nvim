-- Toggleable terminal: <leader>tt
local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'akinsho/toggleterm.nvim' }
require('toggleterm').setup {
  direction = 'float',
  float_opts = { border = 'curved' },
}

vim.keymap.set({ 'n', 't' }, '<leader>tt', '<cmd>ToggleTerm<CR>', { desc = '[T]oggle [T]erminal' })
-- Leave terminal mode with Esc Esc (single Esc still reaches programs like vim/fzf)
vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })
