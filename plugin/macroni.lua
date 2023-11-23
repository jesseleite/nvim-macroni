vim.api.nvim_create_user_command('YankMacro', function (opts)
  require('macroni').yank(unpack(opts.fargs))
end, { nargs = '*' })

