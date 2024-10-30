local exit_insert_mode = function ()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
end

local exit_visual_mode = function ()
  vim.api.nvim_command('normal! '..vim.api.nvim_replace_termcodes('<Esc>', true, false, true))
end

local M = {}

M.get_current_mode = function ()
  return string.lower(vim.api.nvim_get_mode().mode)
end

M.ensure_normal_mode = function ()
  if M.get_current_mode() == 'i' then
    exit_insert_mode()
  elseif M.get_current_mode() == 'v' then
    exit_visual_mode()
  end
end

return M
