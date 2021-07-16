wincent.vim.autocmd('FileType', '*', function()
  local filetype = vim.o.filetype
  local is_js = vim.regex('\\v<javascript|javascriptreact|typescript|typescriptreact>'):match_str(filetype)
  local is_jest = vim.regex('\\v<jest>'):match_str(filetype)

  if is_js and not is_jest then
    local file = vim.fn.expand('<afile>')
    if vim.regex('\\v(Spec|Test|-spec|\\.spec|_spec|-test|\\.test|_test)\\.(js|jsx|ts|tsx)$'):match_str(file) or
      vim.regex('\\v/__tests__|tests?/.+\\.(js|jsx|ts|tsx)$'):match_str(file) then
      vim.cmd('noautocmd set filetype+=.jest')
    end
  end
end)
