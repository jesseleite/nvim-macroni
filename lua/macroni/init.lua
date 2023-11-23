local M = {}

function M.yank(register)
  if not register then
    print('Please specify a register to yank from!')
    return
  end

  local macro = vim.fn.keytrans(vim.fn.getreg(register))
  vim.fn.setreg('+', macro)
  vim.fn.setreg('*', macro)
  vim.fn.setreg('"', macro)

  print('Yanked macro from register `'..register..'`')
end

function M.run(macro)
  vim.cmd.normal(vim.api.nvim_replace_termcodes(macro, true, true, true))
end

return M
