local M = {}

local macros = {}

function M.setup(opts)
  macros = opts.macros or {}

-- Experimental, may change!
  for key,macro in pairs(macros) do
    if macro ~= 'string' and macro.keymap and macro.macro then
      vim.keymap.set('n', macro.keymap, function () M.runSaved(key) end, {
        desc = 'Saved macro: '..(macro.desc or key),
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
  local macro = macros[key]
  if type(macro) == 'string' then
    return M.run(macro)
  end
  return M.run(macro.macro)
end

return M
