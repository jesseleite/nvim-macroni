local M = {}

local config = {
  yank = {
    escape_characters = { '"', "'" },
  },
  macros = {},
}

function M.setup(opts)
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

function M.yank(register)
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

function M.run(macro)
  vim.cmd.normal(vim.api.nvim_replace_termcodes(macro, true, true, true))
end

-- Experimental, may change!
-- TODO: Build telescope picker to easily select a saved macro
function M.runSaved(key)
  local macro = config.macros[key]
  if type(macro) == 'string' then
    return M.run(macro)
  end
  return M.run(macro.macro)
end

return M
