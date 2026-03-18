vim.api.nvim_create_user_command('Shannon', function(opts)
  require('wincent.shannon.private').prompt(opts)
end, { range = true })

vim.api.nvim_create_user_command('ShannonNextMark', function()
  require('wincent.shannon.next_mark')()
end, {})

vim.api.nvim_create_user_command('ShannonPreviousMark', function()
  require('wincent.shannon.previous_mark')()
end, {})

vim.api.nvim_create_user_command('ShannonClearMarks', function()
  require('wincent.shannon.clear_marks')()
end, {})
