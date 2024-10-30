local macroni = require('macroni')
local utils = require('macroni.utils')
local telescope = require('telescope')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local config = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local current_mode

local normalized_macros = function ()
  local macros = {}

  for k,v in pairs(macroni.config().macros) do
    local macro = {}

    macro.key = k

    if v.desc then
      macro.display = k..' ('..v.desc..')'
    else
      macro.display = k
    end

    table.insert(macros, macro)
  end

  return macros
end

local playback_macro_action = function (prompt_bufnr)
  local selection = action_state.get_selected_entry()

  actions.close(prompt_bufnr)

  if current_mode == 'v' then
    macroni.run_saved_on_selection(selection.value)
  else
    macroni.run_saved(selection.value)
  end
end

local saved_macros = function (opts)
  opts = opts or {}

  current_mode = utils.get_current_mode()

  utils.ensure_normal_mode()

  pickers.new(opts, {
    prompt_title = 'Saved Macros',
    sorter = config.generic_sorter(opts),
    finder = finders.new_table {
      results = normalized_macros(),
      entry_maker = function(macro)
        return {
          value = macro.key,
          display = macro.display,
          ordinal = macro.display,
        }
      end,
    },
    attach_mappings = function()
      actions.select_default:replace(playback_macro_action)

      return true
    end,
  }):find()
end

return telescope.register_extension {
  exports = {
    macroni = saved_macros,
    saved_macros = saved_macros,
  }
}
