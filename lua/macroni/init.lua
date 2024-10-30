local utils = require('macroni.utils')

local M = {}

local config = {
  yank = {
    escape_characters = { '"', "'" },
  },
  macros = {},
}

M.setup = function(opts)
  config = vim.tbl_deep_extend('force', config, opts)

  -- Experimental, may change!
  for key,macro in pairs(config.macros) do
    if macro ~= 'string' and macro.keymap and macro.macro then
      vim.keymap.set('n', macro.keymap, function () M.runSaved(key) end, {
        desc = 'Macro: '..(macro.desc or key),
        remap = true,
      })
    end
  end
end

M.config = function ()
  return config
end

M.yank = function (register)
  register = register or vim.fn.input('Please specify a register to yank from: ')
  vim.cmd.mode()

  local register_content = vim.fn.getreg(register)

  if register == '' or register_content == '' then
    print('Invalid register content!')
    return
  end

  local macro = vim.fn.keytrans(register_content)

  for _, character in ipairs(config.yank.escape_characters) do
    macro = string.gsub(macro, character, '\\'..character)
  end

  vim.fn.setreg('+', macro)
  vim.fn.setreg('*', macro)
  vim.fn.setreg('"', macro)

  print('Yanked macro from register `'..register..'`')
end

M.run = function (macro)
  vim.cmd.normal(vim.api.nvim_replace_termcodes(macro, true, true, true))
  utils.ensure_normal_mode()
end

M.run_on_selection = function (macro)
  vim.api.nvim_command(":'<,'>norm "..vim.api.nvim_replace_termcodes(macro, true, true, true))
  utils.ensure_normal_mode()
end

M.run_saved = function (key)
  local macro = config.macros[key]

  if type(macro) ~= 'string' then
    macro = macro.macro
  end

  return M.run(macro)
end

M.run_saved_on_selection = function (key)
  local macro = config.macros[key]

  if type(macro) ~= 'string' then
    macro = macro.macro
  end

  return M.run_on_selection(macro)
end

return M
