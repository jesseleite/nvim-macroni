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
    table.insert(macros, {
      key = k,
      keymap = v.keymap or '',
      desc = v.desc or '',
    })
  end

  return macros
end

local entry_maker = function (opts)
  local displayer = require("telescope.pickers.entry_display").create {
    separator = " ",
    items = {
      { width = opts.width_macro or 30 },
      { width = opts.width_keymap or 20 },
      { remaining = true },
    },
  }

  local make_display = function (entry)
    return displayer {
      entry.value,
      entry.keymap,
      entry.desc,
    }
  end

  return function (entry)
    return {
      value = entry.key,
      keymap = entry.keymap,
      desc = entry.desc,
      ordinal = entry.key .. " " .. entry.keymap .. " " .. entry.desc,
      display = make_display,
    }
  end
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
      entry_maker = entry_maker(opts),
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
