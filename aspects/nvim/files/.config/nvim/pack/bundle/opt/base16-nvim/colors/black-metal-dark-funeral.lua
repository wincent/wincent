-- Black Metal (Dark Funeral) scheme by metalelf0 (https://github.com/metalelf0)
--
-- Generated from this template:
--
-- - base16-nvim (https://github.com/wincent/base16-nvim)
--   by Greg Hurrell (https://github.com/wincent)
--
-- Template based on:
--
-- - base16-vim (https://github.com/chriskempson/base16-vim)
--   by Chris Kempson (https://github.com/chriskempson); and its fork:
-- - tinted-vim (https://github.com/tinted-theming/tinted-vim)
--   by the Tinted Theming contributors.

-- Base16 colors.
local gui00 = "#000000"
local gui01 = "#121212"
local gui02 = "#222222"
local gui03 = "#333333"
local gui04 = "#999999"
local gui05 = "#c1c1c1"
local gui06 = "#999999"
local gui07 = "#c1c1c1"
local gui08 = "#5f8787"
local gui09 = "#aaaaaa"
local gui0A = "#5f81a5"
local gui0B = "#d0dfee"
local gui0C = "#aaaaaa"
local gui0D = "#888888"
local gui0E = "#999999"
local gui0F = "#444444"

-- Base24 colors.
local gui10 = "#000000"
local gui11 = "#000000"
local gui12 = "#5f8787"
local gui13 = "#5f81a5"
local gui14 = "#d0dfee"
local gui15 = "#aaaaaa"
local gui16 = "#888888"
local gui17 = "#999999"

-- Base16 colors.
local cterm00 = 0
local cterm03 = 8
local cterm05 = 7
local cterm07 = 15
local cterm08 = 1
local cterm0A = 3
local cterm0B = 2
local cterm0C = 6
local cterm0D = 4
local cterm0E = 5
local cterm01 = 10
local cterm02 = 11
local cterm04 = 12
local cterm06 = 13
local cterm09 = 9
local cterm0F = 14

-- Base24 colors.
local cterm10  = cterm00
local cterm11  = cterm00
local cterm12  = 9
local cterm13  = 11
local cterm14  = 10
local cterm15  = 14
local cterm16  = 12
local cterm17  = 13

vim.cmd [[
  highlight clear
  syntax reset
]]
vim.g.colors_name = "black-metal-dark-funeral"

-- Vim editor colors
vim.api.nvim_set_hl(0, 'Normal', { fg = gui05, bg = gui00, ctermfg = cterm05, ctermbg = cterm00 })
vim.api.nvim_set_hl(0, 'Bold', { bold = true })
vim.api.nvim_set_hl(0, 'Debug', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'Directory', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'Error', { fg = gui00, bg = gui08, ctermfg = cterm00, ctermbg = cterm08 })
vim.api.nvim_set_hl(0, 'ErrorMsg', { fg = gui08, bg = gui00, ctermfg = cterm08, ctermbg = cterm00 })
vim.api.nvim_set_hl(0, 'Exception', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'FoldColumn', { fg = gui0C, bg = gui01, ctermfg = cterm0C, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'Folded', { fg = gui03, bg = gui01, ctermfg = cterm03, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'IncSearch', { fg = gui01, bg = gui09, ctermfg = cterm01, ctermbg = cterm09 })
vim.api.nvim_set_hl(0, 'Italic', {})
vim.api.nvim_set_hl(0, 'Macro', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'MatchParen', { bg = gui03, ctermbg = cterm03 })
vim.api.nvim_set_hl(0, 'ModeMsg', { fg = gui0B, ctermfg = cterm0B })
vim.api.nvim_set_hl(0, 'MoreMsg', { fg = gui0B, ctermfg = cterm0B })
vim.api.nvim_set_hl(0, 'Question', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'Search', { fg = gui01, bg = gui0A, ctermfg = cterm01, ctermbg = cterm0A })
vim.api.nvim_set_hl(0, 'Substitute', { fg = gui01, bg = gui0A, ctermfg = cterm01, ctermbg = cterm0A })
vim.api.nvim_set_hl(0, 'SpecialKey', { fg = gui03, ctermfg = cterm03 })
vim.api.nvim_set_hl(0, 'TooLong', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'Underlined', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'Visual', { bg = gui02, ctermbg = cterm02 })
vim.api.nvim_set_hl(0, 'VisualNOS', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'WarningMsg', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'WildMenu', { fg = gui08, bg = gui0A, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'Title', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'Conceal', { fg = gui0D, bg = gui00, ctermfg = cterm0D, ctermbg = cterm00 })
vim.api.nvim_set_hl(0, 'Cursor', { fg = gui00, bg = gui05, ctermfg = cterm00, ctermbg = cterm05 })
vim.api.nvim_set_hl(0, 'NonText', { fg = gui03, ctermfg = cterm03 })
vim.api.nvim_set_hl(0, 'LineNr', { fg = gui03, bg = gui01, ctermfg = cterm03, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'SignColumn', { fg = gui03, bg = gui01, ctermfg = cterm03, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'StatusLine', { fg = gui04, bg = gui02, ctermfg = cterm04, ctermbg = cterm02 })
vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = gui03, bg = gui01, ctermfg = cterm03, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'VertSplit', { fg = gui02, bg = gui02, ctermfg = cterm02, ctermbg = cterm02 })
vim.api.nvim_set_hl(0, 'ColorColumn', { bg = gui01, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'CursorColumn', { bg = gui01, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = gui01, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = gui04, bg = gui01, ctermfg = cterm04, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'QuickFixLine', { bg = gui01, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'PMenu', { fg = gui05, bg = gui01, ctermfg = cterm05, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'PMenuSel', { fg = gui01, bg = gui05, ctermfg = cterm01, ctermbg = cterm05 })
vim.api.nvim_set_hl(0, 'TabLine', { fg = gui03, bg = gui01, ctermfg = cterm03, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'TabLineFill', { fg = gui03, bg = gui01, ctermfg = cterm03, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'TabLineSel', { fg = gui0B, bg = gui01, ctermfg = cterm0B, ctermbg = cterm01 })

-- Standard syntax highlighting
vim.api.nvim_set_hl(0, 'Boolean', { fg = gui09, ctermfg = cterm09 })
vim.api.nvim_set_hl(0, 'Character', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'Comment', { fg = gui03, ctermfg = cterm03 })
vim.api.nvim_set_hl(0, 'Conditional', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'Constant', { fg = gui09, ctermfg = cterm09 })
vim.api.nvim_set_hl(0, 'Define', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'Delimiter', { fg = gui0F, ctermfg = cterm0F })
vim.api.nvim_set_hl(0, 'Float', { fg = gui09, ctermfg = cterm09 })
vim.api.nvim_set_hl(0, 'Function', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'Identifier', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'Include', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'Keyword', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'Label', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'Number', { fg = gui09, ctermfg = cterm09 })
vim.api.nvim_set_hl(0, 'Operator', { fg = gui05, ctermfg = cterm05 })
vim.api.nvim_set_hl(0, 'PreProc', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'Repeat', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'Special', { fg = gui0C, ctermfg = cterm0C })
vim.api.nvim_set_hl(0, 'SpecialChar', { fg = gui0F, ctermfg = cterm0F })
vim.api.nvim_set_hl(0, 'Statement', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'StorageClass', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'String', { fg = gui0B, ctermfg = cterm0B })
vim.api.nvim_set_hl(0, 'Structure', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'Tag', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'Todo', { fg = gui0A, bg = gui01, ctermfg = cterm0A, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'Type', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'Typedef', { fg = gui0A, ctermfg = cterm0A })

-- C highlighting
vim.api.nvim_set_hl(0, 'cOperator', { fg = gui0C, ctermfg = cterm0C })
vim.api.nvim_set_hl(0, 'cPreCondit', { fg = gui0E, ctermfg = cterm0E })

-- C# highlighting
vim.api.nvim_set_hl(0, 'csClass', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'csAttribute', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'csModifier', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'csType', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'csUnspecifiedStatement', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'csContextualStatement', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'csNewDecleration', { fg = gui08, ctermfg = cterm08 })

-- CSS highlighting
vim.api.nvim_set_hl(0, 'cssBraces', { fg = gui05, ctermfg = cterm05 })
vim.api.nvim_set_hl(0, 'cssClassName', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'cssColor', { fg = gui0C, ctermfg = cterm0C })

-- Diff highlighting
vim.api.nvim_set_hl(0, 'DiffAdd', { fg = gui0B, bg = gui01, ctermfg =  cterm0B, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'DiffChange', { fg = gui03, bg = gui01, ctermfg =  cterm03, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'DiffDelete', { fg = gui08, bg = gui01, ctermfg =  cterm08, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'DiffText', { fg = gui0D, bg = gui01, ctermfg =  cterm0D, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'DiffAdded', { fg = gui0B, bg = gui00, ctermfg =  cterm0B, ctermbg = cterm00 })
vim.api.nvim_set_hl(0, 'DiffFile', { fg = gui08, bg = gui00, ctermfg =  cterm08, ctermbg = cterm00 })
vim.api.nvim_set_hl(0, 'DiffNewFile', { fg = gui0B, bg = gui00, ctermfg =  cterm0B, ctermbg = cterm00 })
vim.api.nvim_set_hl(0, 'DiffLine', { fg = gui0D, bg = gui00, ctermfg =  cterm0D, ctermbg = cterm00 })
vim.api.nvim_set_hl(0, 'DiffRemoved', { fg = gui08, bg = gui00, ctermfg =  cterm08, ctermbg = cterm00 })

-- Git highlighting
vim.api.nvim_set_hl(0, 'gitcommitOverflow', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'gitcommitSummary', { fg = gui0B, ctermfg = cterm0B })
vim.api.nvim_set_hl(0, 'gitcommitComment', { fg = gui03, ctermfg = cterm03 })
vim.api.nvim_set_hl(0, 'gitcommitUntracked', { fg = gui03, ctermfg = cterm03 })
vim.api.nvim_set_hl(0, 'gitcommitDiscarded', { fg = gui03, ctermfg = cterm03 })
vim.api.nvim_set_hl(0, 'gitcommitSelected', { fg = gui03, ctermfg = cterm03 })
vim.api.nvim_set_hl(0, 'gitcommitHeader', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'gitcommitSelectedType', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'gitcommitUnmergedType', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'gitcommitDiscardedType', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'gitcommitBranch', { fg = gui09, ctermfg = cterm09, bold = true })
vim.api.nvim_set_hl(0, 'gitcommitUntrackedFile', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'gitcommitUnmergedFile', { fg = gui08, ctermfg = cterm08, bold = true })
vim.api.nvim_set_hl(0, 'gitcommitDiscardedFile', { fg = gui08, ctermfg = cterm08, bold = true })
vim.api.nvim_set_hl(0, 'gitcommitSelectedFile', { fg = gui0B, ctermfg = cterm0B, bold = true })

-- GitGutter highlighting
vim.api.nvim_set_hl(0, 'GitGutterAdd', { fg = gui0B, bg = gui01, ctermfg = cterm0B, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'GitGutterChange', { fg = gui0D, bg = gui01, ctermfg = cterm0D, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'GitGutterDelete', { fg = gui08, bg = gui01, ctermfg = cterm08, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'GitGutterChangeDelete', { fg = gui0E, bg = gui01, ctermfg = cterm0E, ctermbg = cterm01 })

-- HTML highlighting
vim.api.nvim_set_hl(0, 'htmlBold', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'htmlItalic', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'htmlEndTag', { fg = gui05, ctermfg = cterm05 })
vim.api.nvim_set_hl(0, 'htmlTag', { fg = gui05, ctermfg = cterm05 })

-- JavaScript highlighting
vim.api.nvim_set_hl(0, 'javaScript', { fg = gui05, ctermfg = cterm05 })
vim.api.nvim_set_hl(0, 'javaScriptBraces', { fg = gui05, ctermfg = cterm05 })
vim.api.nvim_set_hl(0, 'javaScriptNumber', { fg = gui09, ctermfg = cterm09 })

-- pangloss/vim-javascript highlighting
vim.api.nvim_set_hl(0, 'jsOperator', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'jsStatement', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'jsReturn', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'jsThis', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'jsClassDefinition', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'jsFunction', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'jsFuncName', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'jsFuncCall', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'jsClassFuncName', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'jsClassMethodType', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'jsRegexpString', { fg = gui0C, ctermfg = cterm0C })
vim.api.nvim_set_hl(0, 'jsGlobalObjects', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'jsGlobalNodeObjects', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'jsExceptions', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'jsBuiltins', { fg = gui0A, ctermfg = cterm0A })

-- Diagnostics (legacy).
vim.api.nvim_set_hl(0, 'LspDiagnosticsDefaultError', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'LspDiagnosticsDefaultWarning', { fg = gui09, ctermfg = cterm09 })
vim.api.nvim_set_hl(0, 'LspDiagnosticsDefaultInformation', { fg = gui0C, ctermfg = cterm0C })
vim.api.nvim_set_hl(0, 'LspDiagnosticsDefaultHint', { fg = gui0D, ctermfg = cterm0D })

-- Diagnostics (modern).
vim.api.nvim_set_hl(0, 'DiagnosticError', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'DiagnosticWarn', { fg = gui09, ctermfg = cterm09 })
vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = gui0C, ctermfg = cterm0C })
vim.api.nvim_set_hl(0, 'DiagnosticHint', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'DiagnosticOk', { fg = gui0B, ctermfg = cterm0B })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { ctermfg = cterm00, ctermbg = cterm08, underline = true, sp = gui08 })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { ctermfg = cterm00, ctermbg = cterm09, underline = true, sp = gui09 })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { ctermfg = cterm00, ctermbg = cterm0C, underline = true, sp = gui0C })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { ctermfg = cterm00, ctermbg = cterm0D, underline = true, sp = gui0D })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineOk', { ctermfg = cterm00, ctermbg = cterm0B, underline = true, sp = gui0B })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingError', { fg = gui08, bg = gui01, ctermfg = cterm08, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingWarn', { fg = gui09, bg = gui01, ctermfg = cterm09, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingInfo', { fg = gui0C, bg = gui01, ctermfg = cterm0C, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingHint', { fg = gui0D, bg = gui01, ctermfg = cterm0D, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingOk', { fg = gui0B, bg = gui01, ctermfg = cterm0B, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'DiagnosticDeprecated', { ctermfg = cterm0F, ctermbg = cterm0F, strikethrough = true })
vim.api.nvim_set_hl(0, 'DiagnosticUnnecessary', { link = 'Comment' })

-- Mail highlighting
vim.api.nvim_set_hl(0, 'mailQuoted1', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'mailQuoted2', { fg = gui0B, ctermfg = cterm0B })
vim.api.nvim_set_hl(0, 'mailQuoted3', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'mailQuoted4', { fg = gui0C, ctermfg = cterm0C })
vim.api.nvim_set_hl(0, 'mailQuoted5', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'mailQuoted6', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'mailURL', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'mailEmail', { fg = gui0D, ctermfg = cterm0D })

-- Markdown highlighting
vim.api.nvim_set_hl(0, 'markdownCode', { fg = gui0B, ctermfg = cterm0B })
vim.api.nvim_set_hl(0, 'markdownError', { fg = gui05, bg = gui00, ctermfg = cterm05, ctermbg = cterm00 })
vim.api.nvim_set_hl(0, 'markdownCodeBlock', { fg = gui0B, ctermfg = cterm0B })
vim.api.nvim_set_hl(0, 'markdownHeadingDelimiter', { fg = gui0D, ctermfg = cterm0D })

-- NERDTree highlighting
vim.api.nvim_set_hl(0, 'NERDTreeDirSlash', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'NERDTreeExecFile', { fg = gui05, ctermfg = cterm05 })

-- PHP highlighting
vim.api.nvim_set_hl(0, 'phpMemberSelector', { fg = gui05, ctermfg = cterm05 })
vim.api.nvim_set_hl(0, 'phpComparison', { fg = gui05, ctermfg = cterm05 })
vim.api.nvim_set_hl(0, 'phpParent', { fg = gui05, ctermfg = cterm05 })
vim.api.nvim_set_hl(0, 'phpMethodsVar', { fg = gui0C, ctermfg = cterm0C })

-- Python highlighting
vim.api.nvim_set_hl(0, 'pythonOperator', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'pythonRepeat', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'pythonInclude', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'pythonStatement', { fg = gui0E, ctermfg = cterm0E })

-- Ruby highlighting
vim.api.nvim_set_hl(0, 'rubyAttribute', { fg = gui0D, ctermfg = cterm0D })
vim.api.nvim_set_hl(0, 'rubyConstant', { fg = gui0A, ctermfg = cterm0A })
vim.api.nvim_set_hl(0, 'rubyInterpolationDelimiter', { fg = gui0F, ctermfg = cterm0F })
vim.api.nvim_set_hl(0, 'rubyRegexp', { fg = gui0C, ctermfg = cterm0C })
vim.api.nvim_set_hl(0, 'rubySymbol', { fg = gui0B, ctermfg = cterm0B })
vim.api.nvim_set_hl(0, 'rubyStringDelimiter', { fg = gui0B, ctermfg = cterm0B })

-- SASS highlighting
vim.api.nvim_set_hl(0, 'sassidChar', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, 'sassClassChar', { fg = gui09, ctermfg = cterm09 })
vim.api.nvim_set_hl(0, 'sassInclude', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'sassMixing', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'sassMixinName', { fg = gui0D, ctermfg = cterm0D })

-- Signify highlighting
vim.api.nvim_set_hl(0, 'SignifySignAdd', { fg = gui0B, bg = gui01, ctermfg = cterm0B, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'SignifySignChange', { fg = gui0D, bg = gui01, ctermfg = cterm0D, ctermbg = cterm01 })
vim.api.nvim_set_hl(0, 'SignifySignDelete', { fg = gui08, bg = gui01, ctermfg = cterm08, ctermbg = cterm01 })

-- Spelling highlighting
vim.api.nvim_set_hl(0, 'SpellBad', { undercurl = true })
vim.api.nvim_set_hl(0, 'SpellLocal', { undercurl = true })
vim.api.nvim_set_hl(0, 'SpellCap', { undercurl = true })
vim.api.nvim_set_hl(0, 'SpellRare', { undercurl = true })

-- Startify highlighting
vim.api.nvim_set_hl(0, 'StartifyBracket', { fg = gui03, ctermfg = cterm03 })
vim.api.nvim_set_hl(0, 'StartifyFile', { fg = gui07, ctermfg = cterm07 })
vim.api.nvim_set_hl(0, 'StartifyFooter', { fg = gui03, ctermfg = cterm03 })
vim.api.nvim_set_hl(0, 'StartifyHeader', { fg = gui0B, ctermfg = cterm0B })
vim.api.nvim_set_hl(0, 'StartifyNumber', { fg = gui09, ctermfg = cterm09 })
vim.api.nvim_set_hl(0, 'StartifyPath', { fg = gui03, ctermfg = cterm03 })
vim.api.nvim_set_hl(0, 'StartifySection', { fg = gui0E, ctermfg = cterm0E })
vim.api.nvim_set_hl(0, 'StartifySelect', { fg = gui0C, ctermfg = cterm0C })
vim.api.nvim_set_hl(0, 'StartifySlash', { fg = gui03, ctermfg = cterm03 })
vim.api.nvim_set_hl(0, 'StartifySpecial', { fg = gui03, ctermfg = cterm03 })

-- Java highlighting
vim.api.nvim_set_hl(0, 'javaOperator', { fg = gui0D, ctermfg = cterm0D })

-- Treesitter
vim.api.nvim_set_hl(0, '@variable', { link = 'Identifier' })
vim.api.nvim_set_hl(0, '@variable.builtin', { fg = gui05, ctermfg = cterm05, italic = true })
vim.api.nvim_set_hl(0, '@variable.parameter', { link = 'Identifier' })
vim.api.nvim_set_hl(0, '@variable.parameter.builtin', { link = '@variable.builtin' })
vim.api.nvim_set_hl(0, '@variable.member', { fg = gui04, ctermfg = cterm04 })
vim.api.nvim_set_hl(0, '@constant', { link = 'Constant' })
vim.api.nvim_set_hl(0, '@constant.builtin', { fg = gui09, ctermfg = cterm09, italic = true })
vim.api.nvim_set_hl(0, '@constant.macro', { link = 'Constant' })
vim.api.nvim_set_hl(0, '@module', { link = 'Identifier' })
vim.api.nvim_set_hl(0, '@module.builtin', { fg = gui05, ctermfg = cterm05, italic = true })
vim.api.nvim_set_hl(0, '@label', { link = 'Tag' })
vim.api.nvim_set_hl(0, '@string', { link = 'String' })
vim.api.nvim_set_hl(0, '@string.documentation', { link = 'String' })
vim.api.nvim_set_hl(0, '@string.regexp', { link = 'SpecialComment' })
vim.api.nvim_set_hl(0, '@string.escape', { link = 'SpecialComment' })
vim.api.nvim_set_hl(0, '@string.special', { link = 'SpecialComment' })
vim.api.nvim_set_hl(0, '@string.special.symbol', { link = 'SpecialComment' })
vim.api.nvim_set_hl(0, '@string.special.path', { fg = gui0D, ctermfg = cterm0D, italic = true })
vim.api.nvim_set_hl(0, '@string.special.url', { fg = gui08, ctermfg = cterm08, italic = true })
vim.api.nvim_set_hl(0, '@character', { link = 'Character' })
vim.api.nvim_set_hl(0, '@character.special', { link = 'SpecialChar' })
vim.api.nvim_set_hl(0, '@boolean', { link = 'Boolean' })
vim.api.nvim_set_hl(0, '@number', { link = 'Number' })
vim.api.nvim_set_hl(0, '@number.float', { link = 'Float' })
vim.api.nvim_set_hl(0, '@type', { link = 'Type' })
vim.api.nvim_set_hl(0, '@type.builtin', { fg = gui0A, ctermfg = cterm0A, italic = true })
vim.api.nvim_set_hl(0, '@type.definition', { link = 'Typedef' })
vim.api.nvim_set_hl(0, '@attribute', { link = 'Special' })
vim.api.nvim_set_hl(0, '@attribute.builtin', { fg = gui0C, ctermfg = cterm0C, italic = true })
vim.api.nvim_set_hl(0, '@property', { link = '@variable.member' })
vim.api.nvim_set_hl(0, '@function', { fg = gui16, ctermfg = cterm16 })
vim.api.nvim_set_hl(0, '@function.builtin', { fg = gui16, ctermfg = cterm16, italic = true })
vim.api.nvim_set_hl(0, '@function.call', { link = '@function' })
vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })
vim.api.nvim_set_hl(0, '@function.method', { link = 'Function' })
vim.api.nvim_set_hl(0, '@function.method.call', { link = '@function.method' })
vim.api.nvim_set_hl(0, '@constructor', { fg = gui0D, ctermfg = cterm0D, bold = true })
vim.api.nvim_set_hl(0, '@operator', { link = 'Operator' })
vim.api.nvim_set_hl(0, '@keyword', { link = 'Keyword' })
vim.api.nvim_set_hl(0, '@keyword.coroutine', { link = 'Repeat' })
vim.api.nvim_set_hl(0, '@keyword.function', { link = 'Keyword' })
vim.api.nvim_set_hl(0, '@keyword.operator', { link = 'Operator' })
vim.api.nvim_set_hl(0, '@keyword.import', { fg = gui0E, ctermfg = cterm0E, italic = true })
vim.api.nvim_set_hl(0, '@keyword.type', { link = 'Keyword' })
vim.api.nvim_set_hl(0, '@keyword.modifier', { link = 'Repeat' })
vim.api.nvim_set_hl(0, '@keyword.repeat', { link = 'Repeat' })
vim.api.nvim_set_hl(0, '@keyword.return', { link = 'Keyword' })
vim.api.nvim_set_hl(0, '@keyword.debug', { link = 'Debug' })
vim.api.nvim_set_hl(0, '@keyword.exception', { link = 'Exception' })
vim.api.nvim_set_hl(0, '@keyword.conditional', { link = 'Conditional' })
vim.api.nvim_set_hl(0, '@keyword.ternary', { link = 'Conditional' })
vim.api.nvim_set_hl(0, '@keyword.directive', { link = 'PreProc' })
vim.api.nvim_set_hl(0, '@keyword.directive.define', { link = 'Define' })
vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })
vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
vim.api.nvim_set_hl(0, '@punctuation.special', { link = 'Special' })
vim.api.nvim_set_hl(0, '@comment', { link = 'Comment' })
vim.api.nvim_set_hl(0, '@comment.documentation', { link = 'Comment' })
vim.api.nvim_set_hl(0, '@comment.error', { fg = gui08, ctermfg = cterm08, italic = true })
vim.api.nvim_set_hl(0, '@comment.warning', { fg = gui09, ctermfg = cterm09, italic = true })
vim.api.nvim_set_hl(0, '@comment.note', { fg = gui0D, ctermfg = cterm0D, italic = true })
vim.api.nvim_set_hl(0, '@comment.todo', { fg = gui0C, ctermfg = cterm0C, italic = true })
vim.api.nvim_set_hl(0, '@markup.strong', { bold = true })
vim.api.nvim_set_hl(0, '@markup.italic', { italic = true })
vim.api.nvim_set_hl(0, '@markup.strikethrough', { strikethrough = true })
vim.api.nvim_set_hl(0, '@markup.underline', { underline = true })
vim.api.nvim_set_hl(0, '@markup.heading', { link = 'Title' })
vim.api.nvim_set_hl(0, '@markup.quote', { fg = gui0C, ctermfg = cterm0C })
vim.api.nvim_set_hl(0, '@markup.math', { link = 'Special' })
vim.api.nvim_set_hl(0, '@markup.link', { fg = gui08, ctermfg = cterm08 })
vim.api.nvim_set_hl(0, '@markup.link.label', { link = '@markup.link' })
vim.api.nvim_set_hl(0, '@markup.link.url', {  fg = gui09, ctermfg = cterm09 })
vim.api.nvim_set_hl(0, '@markup.raw', { fg = gui0B, ctermfg = cterm0B })
vim.api.nvim_set_hl(0, '@markup.raw.block', { link = '@markup.raw' })
vim.api.nvim_set_hl(0, '@markup.list', { link = 'SpecialChar' })
vim.api.nvim_set_hl(0, '@markup.list.checked', { link = 'DiagnosticOk' })
vim.api.nvim_set_hl(0, '@markup.list.unchecked', { link = 'DiagnosticError' })
vim.api.nvim_set_hl(0, '@diff.plus', { link = 'Added' })
vim.api.nvim_set_hl(0, '@diff.minus', { link = 'Removed' })
vim.api.nvim_set_hl(0, '@diff.delta', { link = 'Changed' })
vim.api.nvim_set_hl(0, '@tag', { link = 'Tag' })
vim.api.nvim_set_hl(0, '@tag.builtin', { fg = gui09, ctermfg = cterm09, italic = true })
vim.api.nvim_set_hl(0, '@tag.attribute', { link = 'Special' })
vim.api.nvim_set_hl(0, '@tag.delimiter', { link = 'Delimiter' })

-- LSP
vim.api.nvim_set_hl(0, '@lsp.type.class', { link = '@type' })
vim.api.nvim_set_hl(0, '@lsp.type.comment', { link = '@comment' })
vim.api.nvim_set_hl(0, '@lsp.type.decorator', { link = '@attribute' })
vim.api.nvim_set_hl(0, '@lsp.type.enum', { link = '@type' })
vim.api.nvim_set_hl(0, '@lsp.type.enumMember', { link = '@constant' })
vim.api.nvim_set_hl(0, '@lsp.type.event', { link = '@type' })
vim.api.nvim_set_hl(0, '@lsp.type.function', { link = '@function' })
vim.api.nvim_set_hl(0, '@lsp.type.interface', { link = '@type' })
vim.api.nvim_set_hl(0, '@lsp.type.keyword', { link = '@keyword' })
vim.api.nvim_set_hl(0, '@lsp.type.macro', { link = '@function.macro' })
vim.api.nvim_set_hl(0, '@lsp.type.method', { link = '@function.method' })
vim.api.nvim_set_hl(0, '@lsp.type.modifier', { link = '@type.modifier' })
vim.api.nvim_set_hl(0, '@lsp.type.namespace', { link = '@module' })
vim.api.nvim_set_hl(0, '@lsp.type.number', { link = '@number' })
vim.api.nvim_set_hl(0, '@lsp.type.operator', { link = '@operator' })
vim.api.nvim_set_hl(0, '@lsp.type.parameter', { link = '@variable.parameter' })
vim.api.nvim_set_hl(0, '@lsp.type.property', { link = '@property' })
vim.api.nvim_set_hl(0, '@lsp.type.regexp', { link = '@string.regexp' })
vim.api.nvim_set_hl(0, '@lsp.type.string', { link = '@string' })
vim.api.nvim_set_hl(0, '@lsp.type.struct', { link = '@type' })
vim.api.nvim_set_hl(0, '@lsp.type.type', { link = '@type' })
vim.api.nvim_set_hl(0, '@lsp.type.typeParameter', { link = '@variable.parameter' })
vim.api.nvim_set_hl(0, '@lsp.type.variable', { link = '@variable' })

-- LSP: Rust
vim.api.nvim_set_hl(0, '@lsp.type.builtinType.rust', { link = '@type.builtin' })
vim.api.nvim_set_hl(0, '@lsp.type.escapeSequence.rust', { link = '@string.escape' })
vim.api.nvim_set_hl(0, '@lsp.type.formatSpecifier.rust', { link = '@operator' })
vim.api.nvim_set_hl(0, '@lsp.type.lifetime.rust', { link = '@attribute' })
vim.api.nvim_set_hl(0, '@lsp.type.punctuation.rust', { link = '@punctuation.delimiter' })
vim.api.nvim_set_hl(0, '@lsp.type.selfKeyword.rust', { link = '@variable.builtin' })
vim.api.nvim_set_hl(0, '@lsp.type.selfTypeKeyword.rust', { link = '@type.builtin' })
vim.api.nvim_set_hl(0, '@lsp.mod.attribute', { italic = true })
vim.api.nvim_set_hl(0, '@lsp.mod.controlFlow', { link = '@keyword.repeat' })
vim.api.nvim_set_hl(0, '@lsp.mod.intraDocLink.rust', { link = '@markup.link' })
vim.api.nvim_set_hl(0, '@lsp.typemod.generic.injected.rust', { link = '@variable' })
vim.api.nvim_set_hl(0, '@lsp.typemod.operator.controlFlow.rust', { link = '@operator' })
vim.api.nvim_set_hl(0, '@lsp.typemod.function.associated.rust', { link = '@function.method' })

-- LSP: Lua
vim.api.nvim_set_hl(0, '@lsp.typemod.keyword.documentation.lua', { link = '@tag' })

-- LSP: Markdown
vim.api.nvim_set_hl(0, '@lsp.type.class.markdown', { link = '@lsp' })

-- LSP (non-syntax)
vim.api.nvim_set_hl(0, 'LspReferenceText', { link = 'Search' })
vim.api.nvim_set_hl(0, 'LspReferenceRead', { fg = gui01, bg = gui14, ctermfg = cterm01, ctermbg = cterm14 })
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { fg = gui01, bg = gui12, ctermfg = cterm01, ctermbg = cterm12 })
vim.api.nvim_set_hl(0, 'LspCodeLens', { link = 'NonText' })
vim.api.nvim_set_hl(0, 'LspCodeLensSeparator', { link = 'LspCodeLens' })
vim.api.nvim_set_hl(0, 'LspInlayHint', { link = 'NonText' })
vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', { link = 'Visual' })

-- vim: filetype=lua
