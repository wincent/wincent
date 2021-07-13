-- We load vim-abolish lazily because it doesn't use autoloading internally.
local abolish = function()
  vim.cmd('packadd vim-abolish')

  vim.cmd('Abolish aboud about')
  vim.cmd('Abolish ahve have')
  vim.cmd('Abolish funciton{,ed,s} function{}')
  vim.cmd('Abolish paramater parameter')
  vim.cmd('Abolish provied{,d,s} provide{}')
  vim.cmd('Abolish strinfigy stringify')
  vim.cmd('Abolish submodlue{,s} submodule{}')
  vim.cmd('Abolish {hte,teh} the')
  vim.cmd('Abolish updaet{,ed,es} update{}')
  vim.cmd('Abolish varient{,s} variant{}')
end

return abolish
