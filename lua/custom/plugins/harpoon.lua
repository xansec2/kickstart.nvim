-- ThePrimeagen's Harpoon 2: <leader>a add, <leader>A remove, <leader>sa search (<C-d> removes), <C-e> edit list
local function gh(repo) return 'https://github.com/' .. repo end

-- plenary.nvim is already installed by telescope in init.lua
vim.pack.add { { src = gh 'ThePrimeagen/harpoon', version = 'harpoon2' } }
local harpoon = require 'harpoon'
harpoon:setup()

-- Telescope picker over the harpoon list, styled like <leader>sf (no preview)
-- <C-d> in the picker removes the selected file from harpoon
local function telescope_harpoon()
  local list = harpoon:list()
  local file_paths = {}
  -- removals leave nil holes in list.items, so don't use ipairs
  for i = 1, list:length() do
    local item = list.items[i]
    if item then table.insert(file_paths, item.value) end
  end

  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Harpoon (<C-d> remove)',
      finder = require('telescope.finders').new_table { results = file_paths },
      sorter = require('telescope.config').values.generic_sorter {},
      previewer = false,
      attach_mappings = function(prompt_bufnr, map)
        local function remove_selected()
          local entry = require('telescope.actions.state').get_selected_entry()
          if not entry then return end
          list:remove { value = entry[1] }
          require('telescope.actions').close(prompt_bufnr)
          telescope_harpoon()
        end
        map({ 'i', 'n' }, '<C-d>', remove_selected)
        return true
      end,
    })
    :find()
end

vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Harpoon [A]dd file' })
vim.keymap.set('n', '<leader>A', function() harpoon:list():remove() end, { desc = 'Harpoon remove current file' })
vim.keymap.set('n', '<leader>sa', telescope_harpoon, { desc = '[S]earch H[a]rpoon files' })
vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon quick menu' })
