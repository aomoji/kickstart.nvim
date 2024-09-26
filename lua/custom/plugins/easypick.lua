return {
  'axkirillov/easypick.nvim',
  requires = 'nvim-telescope/telescope.nvim',
  config = function()
    local easypick = require 'easypick'

    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'

    -- put selected entry on buffer
    local function nvim_put(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        -- print(vim.inspect(selection))
        vim.api.nvim_put({ selection[1] }, '', false, true)
      end)
      return true
    end

    easypick.setup {
      pickers = {
        -- add your custom pickers here
        -- below you can find some examples of what those can look like

        -- list files inside current folder with default previewer
        {
          -- name for your custom picker, that can be invoked using :Easypick <name> (supports tab completion)
          name = 'ls',
          -- the command to execute, output has to be a list of plain text entries
          command = 'ls',
          -- specify your custom previwer, or use one of the easypick.previewers
          previewer = easypick.previewers.default(),
        },

        -- NOTE: prerequisite: open nvim in git repository
        {
          name = 'dbt_model',
          command = "(cd $(git rev-parse --show-toplevel) && rg -o -e \"ref\\('(.*?)'\\)\" -e \"source\\('.*?',\\ *'(.*?)'\\)\" -e \"source\\('(.*?)',\\ *'.*?'\\)\" --type sql -r '$1$2$3' -I | sort | uniq)",
          -- previewer = easypick.previewers.default(),
          action = nvim_put,
        },
      },
    }
    vim.api.nvim_set_keymap('n', '<leader>dm', ':Easypick dbt_model<CR>', { noremap = true })
  end,
}
