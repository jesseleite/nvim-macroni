local M = {}

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

return M
