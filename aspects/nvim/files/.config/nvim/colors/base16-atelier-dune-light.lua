-- base16-nvim (https://github.com/wincent/base16-nvim)
-- by Greg Hurrell (https://github.com/wincent)
-- based on
-- base16-vim (https://github.com/chriskempson/base16-vim)
-- by Chris Kempson (http://chriskempson.com)
-- Atelier Dune Light scheme by Bram de Haan (http://atelierbramdehaan.nl)

local gui00 = "fefbec"
local gui01 = "e8e4cf"
local gui02 = "a6a28c"
local gui03 = "999580"
local gui04 = "7d7a68"
local gui05 = "6e6b5e"
local gui06 = "292824"
local gui07 = "20201d"
local gui08 = "d73737"
local gui09 = "b65611"
local gui0A = "ae9513"
local gui0B = "60ac39"
local gui0C = "1fad83"
local gui0D = "6684e1"
local gui0E = "b854d4"
local gui0F = "d43552"

local cterm00 = "00"
local cterm03 = "08"
local cterm05 = "07"
local cterm07 = "15"
local cterm08 = "01"
local cterm0A = "03"
local cterm0B = "02"
local cterm0C = "06"
local cterm0D = "04"
local cterm0E = "05"
local cterm01 = "10"
local cterm02 = "11"
local cterm04 = "12"
local cterm06 = "13"
local cterm09 = "09"
local cterm0F = "14"

vim.cmd [[
  highlight clear
  syntax reset
]]
vim.g.colors_name = "base16-atelier-dune-light"

local highlight = function(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  attr = attr or ""
  guisp = guisp or ""

  local command = ""

  if guifg ~= "" then
    command = command .. " guifg=#" .. guifg
  end
  if guibg ~= "" then
    command = command .. " guibg=#" .. guibg
  end
  if ctermfg ~= "" then
    command = command .. " ctermfg=" .. ctermfg
  end
  if ctermbg ~= "" then
    command = command .. " ctermbg=" .. ctermbg
  end
  if attr ~= "" then
    command = command .. " gui=" .. attr .. " cterm=" .. attr
  end
  if guisp ~= "" then
    command = command .. " guisp=#" .. guisp
  end

  if command ~= "" then
    vim.cmd("highlight " .. group .. command)
  end
end

-- Vim editor colors
highlight("Normal",        gui05, gui00, cterm05, cterm00, "", "")
highlight("Bold",          "", "", "", "", "bold", "")
highlight("Debug",         gui08, "", cterm08, "", "", "")
highlight("Directory",     gui0D, "", cterm0D, "", "", "")
highlight("Error",         gui00, gui08, cterm00, cterm08, "", "")
highlight("ErrorMsg",      gui08, gui00, cterm08, cterm00, "", "")
highlight("Exception",     gui08, "", cterm08, "", "", "")
highlight("FoldColumn",    gui0C, gui01, cterm0C, cterm01, "", "")
highlight("Folded",        gui03, gui01, cterm03, cterm01, "", "")
highlight("IncSearch",     gui01, gui09, cterm01, cterm09, "none", "")
highlight("Italic",        "", "", "", "", "none", "")
highlight("Macro",         gui08, "", cterm08, "", "", "")
highlight("MatchParen",    "", gui03, "", cterm03,  "", "")
highlight("ModeMsg",       gui0B, "", cterm0B, "", "", "")
highlight("MoreMsg",       gui0B, "", cterm0B, "", "", "")
highlight("Question",      gui0D, "", cterm0D, "", "", "")
highlight("Search",        gui01, gui0A, cterm01, cterm0A,  "", "")
highlight("Substitute",    gui01, gui0A, cterm01, cterm0A, "none", "")
highlight("SpecialKey",    gui03, "", cterm03, "", "", "")
highlight("TooLong",       gui08, "", cterm08, "", "", "")
highlight("Underlined",    gui08, "", cterm08, "", "", "")
highlight("Visual",        "", gui02, "", cterm02, "", "")
highlight("VisualNOS",     gui08, "", cterm08, "", "", "")
highlight("WarningMsg",    gui08, "", cterm08, "", "", "")
highlight("WildMenu",      gui08, gui0A, cterm08, "", "", "")
highlight("Title",         gui0D, "", cterm0D, "", "none", "")
highlight("Conceal",       gui0D, gui00, cterm0D, cterm00, "", "")
highlight("Cursor",        gui00, gui05, cterm00, cterm05, "", "")
highlight("NonText",       gui03, "", cterm03, "", "", "")
highlight("LineNr",        gui03, gui01, cterm03, cterm01, "", "")
highlight("SignColumn",    gui03, gui01, cterm03, cterm01, "", "")
highlight("StatusLine",    gui04, gui02, cterm04, cterm02, "none", "")
highlight("StatusLineNC",  gui03, gui01, cterm03, cterm01, "none", "")
highlight("VertSplit",     gui02, gui02, cterm02, cterm02, "none", "")
highlight("ColorColumn",   "", gui01, "", cterm01, "none", "")
highlight("CursorColumn",  "", gui01, "", cterm01, "none", "")
highlight("CursorLine",    "", gui01, "", cterm01, "none", "")
highlight("CursorLineNr",  gui04, gui01, cterm04, cterm01, "", "")
highlight("QuickFixLine",  "", gui01, "", cterm01, "none", "")
highlight("PMenu",         gui05, gui01, cterm05, cterm01, "none", "")
highlight("PMenuSel",      gui01, gui05, cterm01, cterm05, "", "")
highlight("TabLine",       gui03, gui01, cterm03, cterm01, "none", "")
highlight("TabLineFill",   gui03, gui01, cterm03, cterm01, "none", "")
highlight("TabLineSel",    gui0B, gui01, cterm0B, cterm01, "none", "")

-- Standard syntax highlighting
highlight("Boolean",      gui09, "", cterm09, "", "", "")
highlight("Character",    gui08, "", cterm08, "", "", "")
highlight("Comment",      gui03, "", cterm03, "", "", "")
highlight("Conditional",  gui0E, "", cterm0E, "", "", "")
highlight("Constant",     gui09, "", cterm09, "", "", "")
highlight("Define",       gui0E, "", cterm0E, "", "none", "")
highlight("Delimiter",    gui0F, "", cterm0F, "", "", "")
highlight("Float",        gui09, "", cterm09, "", "", "")
highlight("Function",     gui0D, "", cterm0D, "", "", "")
highlight("Identifier",   gui08, "", cterm08, "", "none", "")
highlight("Include",      gui0D, "", cterm0D, "", "", "")
highlight("Keyword",      gui0E, "", cterm0E, "", "", "")
highlight("Label",        gui0A, "", cterm0A, "", "", "")
highlight("Number",       gui09, "", cterm09, "", "", "")
highlight("Operator",     gui05, "", cterm05, "", "none", "")
highlight("PreProc",      gui0A, "", cterm0A, "", "", "")
highlight("Repeat",       gui0A, "", cterm0A, "", "", "")
highlight("Special",      gui0C, "", cterm0C, "", "", "")
highlight("SpecialChar",  gui0F, "", cterm0F, "", "", "")
highlight("Statement",    gui08, "", cterm08, "", "", "")
highlight("StorageClass", gui0A, "", cterm0A, "", "", "")
highlight("String",       gui0B, "", cterm0B, "", "", "")
highlight("Structure",    gui0E, "", cterm0E, "", "", "")
highlight("Tag",          gui0A, "", cterm0A, "", "", "")
highlight("Todo",         gui0A, gui01, cterm0A, cterm01, "", "")
highlight("Type",         gui0A, "", cterm0A, "", "none", "")
highlight("Typedef",      gui0A, "", cterm0A, "", "", "")

-- C highlighting
highlight("cOperator",   gui0C, "", cterm0C, "", "", "")
highlight("cPreCondit",  gui0E, "", cterm0E, "", "", "")

-- C# highlighting
highlight("csClass",                 gui0A, "", cterm0A, "", "", "")
highlight("csAttribute",             gui0A, "", cterm0A, "", "", "")
highlight("csModifier",              gui0E, "", cterm0E, "", "", "")
highlight("csType",                  gui08, "", cterm08, "", "", "")
highlight("csUnspecifiedStatement",  gui0D, "", cterm0D, "", "", "")
highlight("csContextualStatement",   gui0E, "", cterm0E, "", "", "")
highlight("csNewDecleration",        gui08, "", cterm08, "", "", "")

-- CSS highlighting
highlight("cssBraces",      gui05, "", cterm05, "", "", "")
highlight("cssClassName",   gui0E, "", cterm0E, "", "", "")
highlight("cssColor",       gui0C, "", cterm0C, "", "", "")

-- Diff highlighting
highlight("DiffAdd",      gui0B, gui01,  cterm0B, cterm01, "", "")
highlight("DiffChange",   gui03, gui01,  cterm03, cterm01, "", "")
highlight("DiffDelete",   gui08, gui01,  cterm08, cterm01, "", "")
highlight("DiffText",     gui0D, gui01,  cterm0D, cterm01, "", "")
highlight("DiffAdded",    gui0B, gui00,  cterm0B, cterm00, "", "")
highlight("DiffFile",     gui08, gui00,  cterm08, cterm00, "", "")
highlight("DiffNewFile",  gui0B, gui00,  cterm0B, cterm00, "", "")
highlight("DiffLine",     gui0D, gui00,  cterm0D, cterm00, "", "")
highlight("DiffRemoved",  gui08, gui00,  cterm08, cterm00, "", "")

-- Git highlighting
highlight("gitcommitOverflow",       gui08, "", cterm08, "", "", "")
highlight("gitcommitSummary",        gui0B, "", cterm0B, "", "", "")
highlight("gitcommitComment",        gui03, "", cterm03, "", "", "")
highlight("gitcommitUntracked",      gui03, "", cterm03, "", "", "")
highlight("gitcommitDiscarded",      gui03, "", cterm03, "", "", "")
highlight("gitcommitSelected",       gui03, "", cterm03, "", "", "")
highlight("gitcommitHeader",         gui0E, "", cterm0E, "", "", "")
highlight("gitcommitSelectedType",   gui0D, "", cterm0D, "", "", "")
highlight("gitcommitUnmergedType",   gui0D, "", cterm0D, "", "", "")
highlight("gitcommitDiscardedType",  gui0D, "", cterm0D, "", "", "")
highlight("gitcommitBranch",         gui09, "", cterm09, "", "bold", "")
highlight("gitcommitUntrackedFile",  gui0A, "", cterm0A, "", "", "")
highlight("gitcommitUnmergedFile",   gui08, "", cterm08, "", "bold", "")
highlight("gitcommitDiscardedFile",  gui08, "", cterm08, "", "bold", "")
highlight("gitcommitSelectedFile",   gui0B, "", cterm0B, "", "bold", "")

-- GitGutter highlighting
highlight("GitGutterAdd",     gui0B, gui01, cterm0B, cterm01, "", "")
highlight("GitGutterChange",  gui0D, gui01, cterm0D, cterm01, "", "")
highlight("GitGutterDelete",  gui08, gui01, cterm08, cterm01, "", "")
highlight("GitGutterChangeDelete",  gui0E, gui01, cterm0E, cterm01, "", "")

-- HTML highlighting
highlight("htmlBold",    gui0A, "", cterm0A, "", "", "")
highlight("htmlItalic",  gui0E, "", cterm0E, "", "", "")
highlight("htmlEndTag",  gui05, "", cterm05, "", "", "")
highlight("htmlTag",     gui05, "", cterm05, "", "", "")

-- JavaScript highlighting
highlight("javaScript",        gui05, "", cterm05, "", "", "")
highlight("javaScriptBraces",  gui05, "", cterm05, "", "", "")
highlight("javaScriptNumber",  gui09, "", cterm09, "", "", "")

-- pangloss/vim-javascript highlighting
highlight("jsOperator",          gui0D, "", cterm0D, "", "", "")
highlight("jsStatement",         gui0E, "", cterm0E, "", "", "")
highlight("jsReturn",            gui0E, "", cterm0E, "", "", "")
highlight("jsThis",              gui08, "", cterm08, "", "", "")
highlight("jsClassDefinition",   gui0A, "", cterm0A, "", "", "")
highlight("jsFunction",          gui0E, "", cterm0E, "", "", "")
highlight("jsFuncName",          gui0D, "", cterm0D, "", "", "")
highlight("jsFuncCall",          gui0D, "", cterm0D, "", "", "")
highlight("jsClassFuncName",     gui0D, "", cterm0D, "", "", "")
highlight("jsClassMethodType",   gui0E, "", cterm0E, "", "", "")
highlight("jsRegexpString",      gui0C, "", cterm0C, "", "", "")
highlight("jsGlobalObjects",     gui0A, "", cterm0A, "", "", "")
highlight("jsGlobalNodeObjects", gui0A, "", cterm0A, "", "", "")
highlight("jsExceptions",        gui0A, "", cterm0A, "", "", "")
highlight("jsBuiltins",          gui0A, "", cterm0A, "", "", "")

-- Mail highlighting
highlight("mailQuoted1",  gui0A, "", cterm0A, "", "", "")
highlight("mailQuoted2",  gui0B, "", cterm0B, "", "", "")
highlight("mailQuoted3",  gui0E, "", cterm0E, "", "", "")
highlight("mailQuoted4",  gui0C, "", cterm0C, "", "", "")
highlight("mailQuoted5",  gui0D, "", cterm0D, "", "", "")
highlight("mailQuoted6",  gui0A, "", cterm0A, "", "", "")
highlight("mailURL",      gui0D, "", cterm0D, "", "", "")
highlight("mailEmail",    gui0D, "", cterm0D, "", "", "")

-- Markdown highlighting
highlight("markdownCode",              gui0B, "", cterm0B, "", "", "")
highlight("markdownError",             gui05, gui00, cterm05, cterm00, "", "")
highlight("markdownCodeBlock",         gui0B, "", cterm0B, "", "", "")
highlight("markdownHeadingDelimiter",  gui0D, "", cterm0D, "", "", "")

-- NERDTree highlighting
highlight("NERDTreeDirSlash",  gui0D, "", cterm0D, "", "", "")
highlight("NERDTreeExecFile",  gui05, "", cterm05, "", "", "")

-- PHP highlighting
highlight("phpMemberSelector",  gui05, "", cterm05, "", "", "")
highlight("phpComparison",      gui05, "", cterm05, "", "", "")
highlight("phpParent",          gui05, "", cterm05, "", "", "")
highlight("phpMethodsVar",      gui0C, "", cterm0C, "", "", "")

-- Python highlighting
highlight("pythonOperator",  gui0E, "", cterm0E, "", "", "")
highlight("pythonRepeat",    gui0E, "", cterm0E, "", "", "")
highlight("pythonInclude",   gui0E, "", cterm0E, "", "", "")
highlight("pythonStatement", gui0E, "", cterm0E, "", "", "")

-- Ruby highlighting
highlight("rubyAttribute",               gui0D, "", cterm0D, "", "", "")
highlight("rubyConstant",                gui0A, "", cterm0A, "", "", "")
highlight("rubyInterpolationDelimiter",  gui0F, "", cterm0F, "", "", "")
highlight("rubyRegexp",                  gui0C, "", cterm0C, "", "", "")
highlight("rubySymbol",                  gui0B, "", cterm0B, "", "", "")
highlight("rubyStringDelimiter",         gui0B, "", cterm0B, "", "", "")

-- SASS highlighting
highlight("sassidChar",     gui08, "", cterm08, "", "", "")
highlight("sassClassChar",  gui09, "", cterm09, "", "", "")
highlight("sassInclude",    gui0E, "", cterm0E, "", "", "")
highlight("sassMixing",     gui0E, "", cterm0E, "", "", "")
highlight("sassMixinName",  gui0D, "", cterm0D, "", "", "")

-- Signify highlighting
highlight("SignifySignAdd",     gui0B, gui01, cterm0B, cterm01, "", "")
highlight("SignifySignChange",  gui0D, gui01, cterm0D, cterm01, "", "")
highlight("SignifySignDelete",  gui08, gui01, cterm08, cterm01, "", "")

-- Spelling highlighting
highlight("SpellBad",     "", "", "", "", "undercurl", gui08)
highlight("SpellLocal",   "", "", "", "", "undercurl", gui0C)
highlight("SpellCap",     "", "", "", "", "undercurl", gui0D)
highlight("SpellRare",    "", "", "", "", "undercurl", gui0E)

-- Startify highlighting
highlight("StartifyBracket",  gui03, "", cterm03, "", "", "")
highlight("StartifyFile",     gui07, "", cterm07, "", "", "")
highlight("StartifyFooter",   gui03, "", cterm03, "", "", "")
highlight("StartifyHeader",   gui0B, "", cterm0B, "", "", "")
highlight("StartifyNumber",   gui09, "", cterm09, "", "", "")
highlight("StartifyPath",     gui03, "", cterm03, "", "", "")
highlight("StartifySection",  gui0E, "", cterm0E, "", "", "")
highlight("StartifySelect",   gui0C, "", cterm0C, "", "", "")
highlight("StartifySlash",    gui03, "", cterm03, "", "", "")
highlight("StartifySpecial",  gui03, "", cterm03, "", "", "")

-- Java highlighting
highlight("javaOperator",     gui0D, "", cterm0D, "", "", "")

-- vim: filetype=lua
