vim.cmd([[
  syntax match ChatGPTHeader /^◭🧑 .*/
  syntax match ChatGPTHeader /^◮🤖 .*/
  highlight link ChatGPTHeader TermCursor
]])
