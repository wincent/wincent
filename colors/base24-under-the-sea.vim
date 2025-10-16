" vi:syntax=vim

" tinted-vim (https://github.com/tinted-theming/tinted-vim)
" Scheme name: Under The Sea
" Scheme author: FredHappyface (https://github.com/fredHappyface)
" Template author: Tinted Theming (https://github.com/tinted-theming)

" This enables the coresponding base16-shell script to run so that
" :colorscheme works in terminals supported by tinted-shell scripts
" User must set this variable in .vimrc
"   let g:tinted_shell_path=path/to/shell/scripts
if !has('gui_running')
  if exists('g:tinted_shell_path')
    execute 'silent !/bin/sh '.g:tinted_shell_path.'/base24/under-the-sea.sh'
  endif
endif

" GUI colors
let s:gui00        = '001015'
let s:gui01        = '022026'
let s:gui02        = '374350'
let s:gui03        = '394751'
let s:gui04        = '3b4c52'
let s:gui05        = '3d5053'
let s:gui06        = '405554'
let s:gui07        = '58fad6'
let s:gui08        = 'b12f2c'
let s:gui09        = '58809c'
let s:gui0A        = '61d4b9'
let s:gui0B        = '00a940'
let s:gui0C        = '5c7e19'
let s:gui0D        = '449985'
let s:gui0E        = '00599c'
let s:gui0F        = '581716'
let s:gui10        = '242c35'
let s:gui11        = '12161a'
let s:gui12        = 'ff4242'
let s:gui13        = '8dd3fd'
let s:gui14        = '2aea5e'
let s:gui15        = '98cf28'
let s:gui16        = '61d4b9'
let s:gui17        = '1298ff'

" Terminal colors
let s:cterm00  = '00'
let s:cterm01  = '18'
let s:cterm02  = '19'
let s:cterm03  = '08'
let s:cterm04  = '20'
let s:cterm05  = '21'
let s:cterm06  = '07'
let s:cterm07  = '15'
let s:cterm08  = '01'
let s:cterm09  = '16'
let s:cterm0A  = '03'
let s:cterm0B  = '02'
let s:cterm0C  = '06'
let s:cterm0D  = '04'
let s:cterm0E  = '05'
let s:cterm0F  = '17'
let s:cterm10  = s:cterm00
let s:cterm11  = s:cterm00
let s:cterm12  = '09'
let s:cterm13  = '11'
let s:cterm14  = '10'
let s:cterm15  = '14'
let s:cterm16  = '12'
let s:cterm17  = '13'

" base16_colorspace` and `base16colorspace` are legacy properties and
" exist to keep existing setups from breaking
if (exists('base16_colorspace') && base16_colorspace !=? '256') || (exists('base16colorspace') && base16colorspace !=? '256') || (exists('tinted_colorspace') && tinted_colorspace !=? '256')
  " We have only 16 colors so define fallbacks for codes > 15
  let s:cterm01 = s:cterm00
  let s:cterm02 = s:cterm03
  let s:cterm04 = s:cterm03
  let s:cterm05 = s:cterm06
  let s:cterm07 = s:cterm06
  let s:cterm09 = s:cterm08
  let s:cterm0F = s:cterm08
endif

" Todo! why do we need the globals?
function! s:create_color_globals() abort
  for i in range(0, 23)
    let l:num = printf('%02X', i)
    execute 'let g:tinted_gui' . l:num . ' = s:gui' . l:num
    execute 'let g:tinted_cterm' . l:num . ' = s:cterm' . l:num
    " Legacy vars for lualine
    execute 'let g:base16_gui' . l:num . ' = s:gui' . l:num
  endfor
endfunction

call s:create_color_globals()

" Integrated Terminal colors
let s:colors = [
  \ '#001015',
  \ '#b12f2c',
  \ '#00a940',
  \ '#61d4b9',
  \ '#449985',
  \ '#00599c',
  \ '#5c7e19',
  \ '#3d5053',
  \ '#394751',
  \ '#ff4242',
  \ '#2aea5e',
  \ '#8dd3fd',
  \ '#61d4b9',
  \ '#1298ff',
  \ '#98cf28',
  \ '#58fad6'
\]

if has('nvim')
  for i in range(16)
    let g:terminal_color_{i} = s:colors[i]
  endfor
  let g:terminal_color_background = &background ==? 'light' ? s:colors[7] : s:colors[0]
  let g:terminal_color_foreground = &background ==? 'light' ? s:colors[2] : s:colors[5]
elseif has('terminal')
  let g:terminal_ansi_colors = s:colors
endif

if exists('g:tinted_background_transparent') && g:tinted_background_transparent ==? '1'
  let s:guibg = 'NONE'
  let s:ctermbg = 'NONE'
else
  let s:guibg = s:gui00
  let s:ctermbg = s:cterm00
endif

if !exists('g:tinted_bold')
  let g:tinted_bold = 1
endif

if !exists('g:tinted_italic')
  let g:tinted_italic = 1
endif

if !exists('g:tinted_strikethrough')
  let g:tinted_strikethrough = 1
endif

if !exists('g:tinted_underline')
  let g:tinted_underline = 1
endif

if !exists('g:tinted_undercurl')
  let g:tinted_undercurl = g:tinted_underline
endif

let s:attrs = {
      \ 'bold': g:tinted_bold,
      \ 'italic': g:tinted_italic,
      \ 'strikethrough': g:tinted_strikethrough,
      \ 'underline': g:tinted_underline,
      \ 'undercurl': g:tinted_undercurl,
      \}

" Theme setup
let g:colors_name = 'base24-under-the-sea'

" Highlighting function
" Optional variables are attributes and guisp
function! g:Tinted_Hi(group, guifg, guibg, ctermfg, ctermbg, ...)

  " Clear the highlight to be more robust against default Highlighting changes
  exec 'hi! clear ' . a:group

  let l:attr = join(filter(split(get(a:, 1, ''), ','), 'get(s:attrs, v:val, 1)'), ',')
  let l:guisp = get(a:, 2, '')

  " See :help highlight-guifg
  let l:gui_special_names = ['NONE', 'bg', 'background', 'fg', 'foreground']

  if a:guifg !=? ''
    if index(l:gui_special_names, a:guifg) >= 0
      exec 'hi! ' . a:group . ' guifg=' . a:guifg
    else
      exec 'hi! ' . a:group . ' guifg=#' . a:guifg
    endif
  endif
  if a:guibg !=? ''
    if index(l:gui_special_names, a:guibg) >= 0
      exec 'hi! ' . a:group . ' guibg=' . a:guibg
    else
      exec 'hi! ' . a:group . ' guibg=#' . a:guibg
    endif
  endif
  if a:ctermfg !=? ''
    exec 'hi! ' . a:group . ' ctermfg=' . a:ctermfg
  endif
  if a:ctermbg !=? ''
    exec 'hi! ' . a:group . ' ctermbg=' . a:ctermbg
  endif
  if l:attr !=? ''
    exec 'hi! ' . a:group . ' gui=' . l:attr . ' cterm=' . l:attr
  endif
  if l:guisp !=? ''
    if index(l:gui_special_names, l:guisp) >= 0
      exec 'hi! ' . a:group . ' guisp=' . l:guisp
    else
      exec 'hi! ' . a:group . ' guisp=#' . l:guisp
    endif
  endif
endfunction


fun <sid>hi(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  call g:Tinted_Hi(a:group, a:guifg, a:guibg, a:ctermfg, a:ctermbg, a:attr, a:guisp)
endfun


" Tinted color highlights

call <sid>hi('tinted_gui00', s:gui00, '', s:cterm00, '', '', '')
call <sid>hi('tinted_gui01', s:gui01, '', s:cterm01, '', '', '')
call <sid>hi('tinted_gui02', s:gui02, '', s:cterm02, '', '', '')
call <sid>hi('tinted_gui03', s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('tinted_gui04', s:gui04, '', s:cterm04, '', '', '')
call <sid>hi('tinted_gui05', s:gui05, '', s:cterm05, '', '', '')
call <sid>hi('tinted_gui06', s:gui06, '', s:cterm06, '', '', '')
call <sid>hi('tinted_gui07', s:gui07, '', s:cterm07, '', '', '')
call <sid>hi('tinted_gui08', s:gui08, '', s:cterm08, '', '', '')
call <sid>hi('tinted_gui09', s:gui09, '', s:cterm09, '', '', '')
call <sid>hi('tinted_gui0A', s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('tinted_gui0B', s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('tinted_gui0C', s:gui0C, '', s:cterm0C, '', '', '')
call <sid>hi('tinted_gui0D', s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('tinted_gui0E', s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('tinted_gui0F', s:gui0F, '', s:cterm0F, '', '', '')
call <sid>hi('tinted_gui10', s:gui10, '', s:cterm10, '', '', '')
call <sid>hi('tinted_gui11', s:gui11, '', s:cterm11, '', '', '')
call <sid>hi('tinted_gui12', s:gui12, '', s:cterm12, '', '', '')
call <sid>hi('tinted_gui13', s:gui13, '', s:cterm13, '', '', '')
call <sid>hi('tinted_gui14', s:gui14, '', s:cterm14, '', '', '')
call <sid>hi('tinted_gui15', s:gui15, '', s:cterm15, '', '', '')
call <sid>hi('tinted_gui16', s:gui16, '', s:cterm16, '', '', '')
call <sid>hi('tinted_gui17', s:gui17, '', s:cterm17, '', '', '')

" Vim editor colors

call <sid>hi('ColorColumn',   '', s:gui01, '', s:cterm01, '', '')
call <sid>hi('Conceal',       s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('CurSearch',     s:gui00, s:gui14, s:cterm00, s:cterm14,  '', '')
call <sid>hi('Cursor',        'bg', 'fg', '', '', '', '')
hi! link lCursor Cursor
hi! link CursorIM Cursor
call <sid>hi('CursorColumn',  '', s:gui01, '', s:cterm01, 'none', '')
call <sid>hi('CursorLine',    '', s:gui01, '', s:cterm01, 'none', '')
call <sid>hi('Directory',     s:gui0D, '', s:cterm0D, '', '', '')

" Diff
call <sid>hi('DiffAdd',       '', s:gui01,  '', s:cterm01, '', '')
call <sid>hi('DiffChange',    '', s:gui01,  '', s:cterm01, '', '')
call <sid>hi('DiffDelete',    s:gui03, s:guibg,  s:cterm03, s:ctermbg, '', '')
call <sid>hi('DiffText',      '', s:gui02,  '', s:cterm02, '', '')

call <sid>hi('EndOfBuffer',   s:guibg, s:guibg, s:ctermbg, s:ctermbg, '', '')
call <sid>hi('ErrorMsg',      s:gui08, '', s:cterm08, '', '', '')
if has('nvim')
  call <sid>hi('WinSeparator',  s:gui01, s:guibg, s:cterm01, s:ctermbg, '', '')
else
  call <sid>hi('VertSplit',  s:gui01, s:guibg, s:cterm01, s:ctermbg, '', '')
endif
call <sid>hi('Folded',        s:gui13, s:guibg, s:cterm13, s:ctermbg, '', '')
call <sid>hi('FoldColumn',    s:gui03, s:guibg, s:cterm03, s:ctermbg, '', '')
call <sid>hi('SignColumn',    s:gui03, s:guibg, s:cterm03, s:ctermbg, '', '')
hi! link IncSearch CurSearch
hi! link Substitute Search
call <sid>hi('LineNr',        s:gui03, s:guibg, s:cterm03, s:ctermbg, '', '')
hi! link LineNrAbove LineNr
hi! link LineNrBelow LineNr
call <sid>hi('CursorLineNr',   s:gui04, s:guibg, s:cterm04, s:ctermbg, 'bold', '')
call <sid>hi('CursorLineFold', s:gui13, s:guibg, s:cterm13, s:ctermbg, '', '')
hi! link CursorLineSign SignColumn
call <sid>hi('MatchParen',     s:gui06, '', s:cterm06, '',  'bold', '')
call <sid>hi('ModeMsg',        s:gui05, '', s:cterm05, '', '', '')
hi! link MsgArea None
hi! link MsgSeparator WinSeparator
call <sid>hi('MoreMsg',        s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('NonText',        s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('Normal',         s:gui05, s:guibg, s:cterm05, s:ctermbg, '', '')
call <sid>hi('NormalFloat',    s:gui06, s:gui01, s:cterm06, s:cterm01, 'none', '')
call <sid>hi('FloatBorder',    s:gui06, s:gui01, s:cterm06, s:cterm01, 'none', '')
hi! link FloatTitle Title
hi! link FloatFooter FloatTitle
hi! link NormalNC None
call <sid>hi('PMenu',           s:gui05, s:gui01, s:cterm05, s:cterm01, 'none', '')
call <sid>hi('PMenuSel', s:gui06, s:gui02, s:cterm06, s:cterm02, 'none', '')
hi! link PMenuKind PMenu
hi! link PMenuKindSel PMenuSel
hi! link PMenuExtra PMenu
hi! link PMenuExtraSel PMenuSel
call <sid>hi('PMenuSbar',      '', s:gui03, '', s:cterm03, '', '')
call <sid>hi('PMenuThumb',     '', s:gui04, '', s:cterm04, '', '')
call <sid>hi('PMenuMatch',     s:gui0C, '', s:cterm0C, '', '', '')
call <sid>hi('PMenuMatchSel',  s:gui15, s:gui02, s:cterm15, s:cterm02, 'none', '')
call <sid>hi('Question',       s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('QuickFixLine',   '', s:gui01, '', s:cterm01, 'none', '')
call <sid>hi('Search',         s:gui01, s:gui13, s:cterm01, s:cterm13,  '', '')
hi! link SnippetTabstop Visual
call <sid>hi('SpecialKey',     s:gui03, '', s:cterm03, '', '', '')

" Spell
call <sid>hi('SpellBad',       '', '', s:ctermbg, s:cterm12, 'undercurl', s:gui08)
call <sid>hi('SpellLocal',     '', '', s:ctermbg, s:cterm15, 'undercurl', s:gui15)
call <sid>hi('SpellCap',       '', '', s:ctermbg, s:cterm16, 'undercurl', s:gui16)
call <sid>hi('SpellRare',      '', '', s:ctermbg, s:cterm0E, 'undercurl', s:gui0E)

call <sid>hi('StatusLine',     s:gui04, s:gui01, s:cterm04, s:cterm01, 'none', '')
call <sid>hi('StatusLineNC',   s:gui03, s:gui01, s:cterm03, s:cterm01, 'none', '')
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC
hi! link TabLine StatusLine
call <sid>hi('TabLineSel',     s:gui01, s:gui04, s:cterm01, s:cterm04, 'none', '')
hi! link TabLineFill StatusLine

call <sid>hi('Title',          s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('Visual',         '', s:gui02, '', s:cterm02, '', '')
hi! link VisualNOS Visual
call <sid>hi('WarningMsg',     s:gui09, '', s:cterm09, '', '', '')
call <sid>hi('Whitespace',     s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('WildMenu',       s:guibg, s:gui05, s:ctermbg, s:cterm05, '', '')
hi! link WinBar StatusLine
hi! link WinBarNC StatusLineNC

" call <sid>hi('Menu',          s:guibg, s:gui05, s:ctermbg, s:cterm05, '', '")
" call <sid>hi('Scrollbar',     s:guibg, s:gui05, s:ctermbg, s:cterm05, '', '")
" call <sid>hi('Tooltip',       s:guibg, s:gui05, s:ctermbg, s:cterm05, '', '")


" Standard syntax

call <sid>hi('Comment',        s:gui03, '', s:cterm03, '', 'italic', '')

call <sid>hi('Constant',       s:gui09, '', s:cterm09, '', 'none', '')
call <sid>hi('String',         s:gui0B, '', s:cterm0B, '', 'italic', '')
call <sid>hi('Character',      s:gui0C, '', s:cterm0C, '', 'none', '')
call <sid>hi('Number',         s:gui09, '', s:cterm09, '', 'none', '')
call <sid>hi('Boolean',        s:gui09, '', s:cterm09, '', 'none', '')
call <sid>hi('Float',          s:gui09, '', s:cterm09, '', 'none', '')

" The [spec](https://github.com/tinted-theming/base24/blob/main/styling.md) wants
" `Identifier` mapped to base08 aka RED. I do not like it, too much RED.
call <sid>hi('Identifier',     s:gui05, '', s:cterm05, '', 'none', '')
call <sid>hi('Function',       s:gui0D, '', s:cterm0D, '', 'none', '')

call <sid>hi('Statement',      s:gui0E, '', s:cterm0E, '', 'bold', '')
call <sid>hi('Conditional',    s:gui0E, '', s:cterm0E, '', 'none', '')
call <sid>hi('Repeat',         s:gui0E, '', s:cterm0E, '', 'none', '')
call <sid>hi('Label',          s:gui0E, '', s:cterm0E, '', 'none', '')
call <sid>hi('Operator',       s:gui0C, '', s:cterm0C, '', 'none', '')
hi! link Keyword Statement
call <sid>hi('Exception',      s:gui0E, '', s:cterm0E, '', 'none', '')

call <sid>hi('PreProc',        s:gui0C, '', s:cterm0C, '', 'none', '')
call <sid>hi('Include',        s:gui0C, '', s:cterm0C, '', 'none', '')
call <sid>hi('Define',         s:gui0C, '', s:cterm0C, '', 'none', '')
call <sid>hi('Macro',          s:gui0C, '', s:cterm0C, '', 'none', '')
call <sid>hi('PreCondit',      s:gui0C, '', s:cterm0C, '', 'none', '')

call <sid>hi('Type',           s:gui0A, '', s:cterm0A, '', 'none', '')
call <sid>hi('StorageClass',   s:gui0A, '', s:cterm0A, '', 'none', '')
call <sid>hi('Structure',      s:gui0A, '', s:cterm0A, '', 'none', '')
call <sid>hi('Typedef',        s:gui0A, '', s:cterm0A, '', 'none', '')

call <sid>hi('Special',        s:gui0C, '', s:cterm0C, '', 'none', '')
call <sid>hi('SpecialChar',    s:gui0A, '', s:cterm0A, '', 'none', '')
call <sid>hi('Tag',            s:gui09, '', s:cterm09, '', 'none', '')
call <sid>hi('Delimiter',      s:gui05, '', s:cterm05, '', 'none', '')
call <sid>hi('SpecialComment', s:gui0A, '', s:cterm0A, '', 'italic', '')

call <sid>hi('Debug',          s:gui08, '', s:cterm08, '', 'none', '')

call <sid>hi('Underlined',     '', '', '', '', 'underline', '')

hi! link Ignore Normal

call <sid>hi('Error',          s:gui08, s:guibg, s:cterm08, s:ctermbg, 'bold', '')

call <sid>hi('Todo',           s:gui0C, '', s:cterm0C, '', 'none', '')

call <sid>hi('Added',          s:gui14, '', s:cterm14, '', 'italic', '')
call <sid>hi('Changed',        s:gui16, '', s:cterm16, '', 'italic', '')
call <sid>hi('Removed',        s:gui12, '', s:cterm12, '', 'italic', '')


" Treesitter Syntax

if has('nvim-0.8.0')
  hi! link @variable Identifier
  call <sid>hi('@variable.builtin',           s:gui05, '', s:cterm05, '', 'italic', '')
  hi! link @variable.parameter Identifier
  hi! link @variable.parameter.builtin @variable.builtin
  call <sid>hi('@variable.member',            s:gui04, '', s:cterm04, '', 'none', '')

  hi! link @constant Constant
  call <sid>hi('@constant.builtin',           s:gui09, '', s:cterm09, '', 'italic', '')
  hi! link @constant.macro Constant

  hi! link @module Identifier
  call <sid>hi('@module.builtin',             s:gui05, '', s:cterm05, '', 'italic', '')
  hi! link @label Tag

  hi! link @string String
  hi! link @string.documentation String
  hi! link @string.regexp SpecialComment
  hi! link @string.escape SpecialComment
  hi! link @string.special SpecialComment
  hi! link @string.special.symbol SpecialComment
  call <sid>hi('@string.special.path',        s:gui0D, '', s:cterm0D, '', 'italic', '')
  call <sid>hi('@string.special.url',         s:gui08, '', s:cterm08, '', 'italic', '')

  hi! link @character Character
  hi! link @character.special SpecialChar

  hi! link @boolean Boolean
  hi! link @number Number
  hi! link @number.float Float

  hi! link @type Type
  call <sid>hi('@type.builtin',               s:gui0A, '', s:cterm0A, '', 'italic', '')
  hi! link @type.definition Typedef

  hi! link @attribute Special
  call <sid>hi('@attribute.builtin',          s:gui0C, '', s:cterm0C, '', 'italic', '')
  hi! link @property @variable.member

  call <sid>hi('@function',                   s:gui16, '', s:cterm16, '', '', '')
  call <sid>hi('@function.builtin',           s:gui16, '', s:cterm16, '', 'italic', '')
  hi! link @function.call @function
  hi! link @function.macro Macro

  hi! link @function.method Function
  hi! link @function.method.call @function.method

  call <sid>hi('@constructor',                s:gui0D, '', s:cterm0D, '', 'bold', '')

  hi! link @operator Operator

  hi! link @keyword Keyword
  hi! link @keyword.coroutine Repeat
  hi! link @keyword.function Keyword
  hi! link @keyword.operator Operator
  call <sid>hi('@keyword.import',             s:gui0E, '', s:cterm0E, '', 'italic', '')
  hi! link @keyword.type Keyword
  hi! link @keyword.modifier Repeat
  hi! link @keyword.repeat Repeat
  hi! link @keyword.return Keyword
  hi! link @keyword.debug Debug
  hi! link @keyword.exception Exception

  hi! link @keyword.conditional Conditional
  hi! link @keyword.ternary Conditional

  hi! link @keyword.directive PreProc
  hi! link @keyword.directive.define Define

  hi! link @punctuation.delimiter Delimiter
  hi! link @punctuation.bracket Delimiter
  hi! link @punctuation.special Special

  hi! link @comment Comment
  hi! link @comment.documentation Comment

  call <sid>hi('@comment.error',   s:gui08, '', s:cterm08, '', 'italic', '')
  call <sid>hi('@comment.warning', s:gui09, '', s:cterm09, '', 'italic', '')
  call <sid>hi('@comment.note',    s:gui0D, '', s:cterm0D, '', 'italic', '')
  call <sid>hi('@comment.todo',    s:gui0C, '', s:cterm0C, '', 'italic', '')

  if (g:tinted_bold == 1)
    hi! @markup.strong        gui=bold          cterm=bold
  endif
  if (g:tinted_italic == 1)
    hi! @markup.italic        gui=italic        cterm=italic
  endif
  if (g:tinted_strikethrough == 1)
    hi! @markup.strikethrough gui=strikethrough cterm=strikethrough
  endif
  if (g:tinted_underline == 1)
    hi! @markup.underline     gui=underline     cterm=underline
  endif

  hi! link @markup.heading Title
  hi! link @markup.quote String
  hi! link @markup.math Special

  call <sid>hi('@markup.link',  s:gui08, '', s:cterm08, '', '', '')
  hi! link @markup.link.label   @markup.link
  hi! link @markup.link.url     Identifier

  call <sid>hi('@markup.raw',   s:gui04, '', s:cterm04, '', '', '')
  hi! link @markup.raw.block Identifier

  hi! link @markup.list SpecialChar
  hi! link @markup.list.checked DiagnosticOk
  hi! link @markup.list.unchecked DiagnosticError

  hi! link @diff.plus Added
  hi! link @diff.minus Removed
  hi! link @diff.delta Changed

  hi! link @tag                 Tag
  call <sid>hi('@tag.builtin',  s:gui09, '', s:cterm09, '', 'italic', '')
  hi! link @tag.attribute       Special
  hi! link @tag.delimiter       Delimiter


  " LSP Semantic Token
  " https://microsoft.github.io/language-server-protocol/specifications/lsp/3.18/specification/#textDocument_semanticTokens
  hi! link @lsp.type.class @type
  hi! link @lsp.type.comment @comment
  hi! link @lsp.type.decorator @attribute
  hi! link @lsp.type.enum @type
  hi! link @lsp.type.enumMember @constant
  hi! link @lsp.type.event @type
  hi! link @lsp.type.function @function
  hi! link @lsp.type.interface @type
  hi! link @lsp.type.keyword @keyword
  hi! link @lsp.type.macro @function.macro
  hi! link @lsp.type.method @function.method
  hi! link @lsp.type.modifier @type.modifier
  hi! link @lsp.type.namespace @module
  hi! link @lsp.type.number @number
  hi! link @lsp.type.operator @operator
  hi! link @lsp.type.parameter @variable.parameter
  hi! link @lsp.type.property @property
  hi! link @lsp.type.regexp @string.regexp
  hi! link @lsp.type.string @string
  hi! link @lsp.type.struct @type
  hi! link @lsp.type.type @type
  hi! link @lsp.type.typeParameter @variable.parameter
  hi! link @lsp.type.variable @variable

  " @lsp.mod.abstract        Types and member functions that are abstract
  " @lsp.mod.async           Functions that are marked async
  " @lsp.mod.declaration     Declarations of symbols
  call <sid>hi('@lsp.mod.defaultLibrary',    '', '', '', '', 'italic', '')
  " @lsp.mod.definition      Definitions of symbols, for example, in header files
  hi! link @lsp.mod.deprecated DiagnosticDeprecated
  " @lsp.mod.modification    Variable references where the variable is assigned to
  " @lsp.mod.readonly        Readonly variables and member fields (constants)
  " @lsp.mod.static

  " Rust
  hi! link @lsp.type.builtinType.rust               @type.builtin
  hi! link @lsp.type.escapeSequence.rust            @string.escape
  hi! link @lsp.type.formatSpecifier.rust           @operator
  hi! link @lsp.type.lifetime.rust                  @attribute
  hi! link @lsp.type.punctuation.rust               @punctuation.delimiter
  hi! link @lsp.type.selfKeyword.rust               @variable.builtin
  hi! link @lsp.type.selfTypeKeyword.rust           @type.builtin

  call <sid>hi('@lsp.mod.attribute',                '', '', '', '', 'italic', '')
  hi! link @lsp.mod.controlFlow                     @keyword.repeat
  hi! link @lsp.mod.intraDocLink.rust               @markup.link

  hi! link @lsp.typemod.generic.injected.rust       @variable
  hi! link @lsp.typemod.operator.controlFlow.rust   @operator
  hi! link @lsp.typemod.function.associated.rust    @function.method

  " LUA
  hi! link @lsp.typemod.keyword.documentation.lua   @tag

  " Markdown
  hi! link @lsp.type.class.markdown @lsp


  " LSP not syntax

  hi! link LspReferenceText Search
  call <sid>hi('LspReferenceRead',  s:gui01, s:gui14, s:cterm01, s:cterm14, '', '')
  call <sid>hi('LspReferenceWrite', s:gui01, s:gui12, s:cterm01, s:cterm12, '', '')
  hi! link LspCodeLens NonText
  hi! link LspCodeLensSeparator LspCodeLens
  hi! link LspInlayHint NonText
  hi! link LspSignatureActiveParameter Visual
endif


" Diagnostics

call <sid>hi('DiagnosticError',          s:gui08, '', s:cterm08, '', '', '')
call <sid>hi('DiagnosticWarn',           s:gui09, '', s:cterm09, '', '', '')
call <sid>hi('DiagnosticInfo',           s:gui0C, '', s:cterm0C, '', '', '')
call <sid>hi('DiagnosticHint',           s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('DiagnosticOk',             s:gui0B, '', s:cterm0B, '', '', '')

call <sid>hi('DiagnosticUnderlineError', '', '', s:ctermbg, s:cterm08, 'underline', s:gui08)
call <sid>hi('DiagnosticUnderlineWarn',  '', '', s:ctermbg, s:cterm09, 'underline', s:gui09)
call <sid>hi('DiagnosticUnderlineInfo',  '', '', s:ctermbg, s:cterm0C, 'underline', s:gui0C)
call <sid>hi('DiagnosticUnderlineHint',  '', '', s:ctermbg, s:cterm0D, 'underline', s:gui0D)
call <sid>hi('DiagnosticUnderlineOk',    '', '', s:ctermbg, s:cterm0B, 'underline', s:gui0B)

call <sid>hi('DiagnosticFloatingError',  s:gui08, s:gui01, s:cterm08, s:cterm01, '', '')
call <sid>hi('DiagnosticFloatingWarn',   s:gui09, s:gui01, s:cterm09, s:cterm01, '', '')
call <sid>hi('DiagnosticFloatingInfo',   s:gui0C, s:gui01, s:cterm0C, s:cterm01, '', '')
call <sid>hi('DiagnosticFloatingHint',   s:gui0D, s:gui01, s:cterm0D, s:cterm01, '', '')
call <sid>hi('DiagnosticFloatingOk',     s:gui0B, s:gui01, s:cterm0B, s:cterm01, '', '')

call <sid>hi('DiagnosticDeprecated',     '', '', s:cterm0F, s:cterm0F, 'strikethrough', '')
hi! link DiagnosticUnnecessary Comment


" Syntax Files

" C
call <sid>hi('cOperator',   s:gui0C, '', s:cterm0C, '', '', '')
call <sid>hi('cPreCondit',  s:gui0E, '', s:cterm0E, '', '', '')

" CSS
call <sid>hi('cssBraces',      s:gui05, '', s:cterm05, '', '', '')
call <sid>hi('cssClassName',   s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('cssColor',       s:gui0C, '', s:cterm0C, '', '', '')

" C#
call <sid>hi('csClass',                s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('csAttribute',            s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('csModifier',             s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('csType',                 s:gui08, '', s:cterm08, '', '', '')
call <sid>hi('csUnspecifiedStatement', s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('csContextualStatement',  s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('csNewDecleration',       s:gui08, '', s:cterm08, '', '', '')

" Git
call <sid>hi('GitAddSign',          s:gui14, '', s:cterm14, '', '', '')
call <sid>hi('GitChangeSign',       s:gui04, '', s:cterm04, '', '', '')
call <sid>hi('GitDeleteSign',       s:gui12, '', s:cterm12, '', '', '')
call <sid>hi('GitChangeDeleteSign', s:gui12, '', s:cterm12, '', '', '')

" Gitcommit
call <sid>hi('gitcommitOverflow',      s:gui08, '', s:cterm08, '', '', '')
call <sid>hi('gitcommitSummary',       s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('gitcommitComment',       s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('gitcommitUntracked',     s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('gitcommitDiscarded',     s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('gitcommitSelected',      s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('gitcommitHeader',        s:gui17, '', s:cterm17, '', '', '')
call <sid>hi('gitcommitSelectedType',  s:gui16, '', s:cterm16, '', '', '')
call <sid>hi('gitcommitUnmergedType',  s:gui16, '', s:cterm16, '', '', '')
call <sid>hi('gitcommitDiscardedType', s:gui16, '', s:cterm16, '', '', '')
call <sid>hi('gitcommitBranch',        s:gui13, '', s:cterm13, '', 'bold', '')
call <sid>hi('gitcommitUntrackedFile', s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('gitcommitUnmergedFile',  s:gui08, '', s:cterm08, '', 'bold', '')
call <sid>hi('gitcommitDiscardedFile', s:gui08, '', s:cterm08, '', 'bold', '')
call <sid>hi('gitcommitSelectedFile',  s:gui0B, '', s:cterm0B, '', 'bold', '')

" Gitsigns
call <sid>hi('GitSignsAddInline',           s:gui14, s:gui02, s:cterm14, s:cterm02, '', '')
call <sid>hi('GitSignsChangeInline',        s:gui16, s:gui02, s:cterm16, s:cterm02, '', '')
call <sid>hi('GitSignsDeleteLnInline',      s:gui12, s:gui02, s:cterm12, s:cterm02, '', '')
call <sid>hi('GitSignsDeleteVirtLnInline',  s:gui16, s:gui02, s:cterm16, s:cterm02, '', '')
call <sid>hi('GitSignsDeleteVirtLn',        s:gui05, s:gui02, s:cterm05, s:cterm02, '', '')

" HTML
call <sid>hi('htmlBold',   s:gui05, '', s:cterm0A, '', 'bold', '')
call <sid>hi('htmlItalic', s:gui05, '', s:cterm17, '', 'italic', '')
call <sid>hi('htmlEndTag', s:gui05, '', s:cterm05, '', '', '')
call <sid>hi('htmlTag',    s:gui05, '', s:cterm05, '', '', '')

" JavaScript
call <sid>hi('javaScript',       s:gui05, '', s:cterm05, '', '', '')
call <sid>hi('javaScriptBraces', s:gui05, '', s:cterm05, '', '', '')
call <sid>hi('javaScriptNumber', s:gui09, '', s:cterm09, '', '', '')

" Mail
call <sid>hi('mailQuoted1', s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('mailQuoted2', s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('mailQuoted3', s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('mailQuoted4', s:gui0C, '', s:cterm0C, '', '', '')
call <sid>hi('mailQuoted5', s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('mailQuoted6', s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('mailURL',     s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('mailEmail',   s:gui0D, '', s:cterm0D, '', '', '')

" Markdown
call <sid>hi('markdownCode',             s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('markdownError',            s:gui05, s:guibg, s:cterm05, s:ctermbg, '', '')
call <sid>hi('markdownCodeBlock',        s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('markdownHeadingDelimiter', s:gui0D, '', s:cterm0D, '', '', '')

" Neogit

hi! link NeogitHunkHeader Special
hi! link NeogitDiffHeader Directory
call <sid>hi('NeogitDiffContext',           s:gui03, '', s:cterm03, '', 'italic', '')
hi! link NeogitDiffAdd Added
hi! link NeogitDiffDelete Removed

hi! link NeogitHunkHeaderHighlight Special
hi! link NeogitDiffHeaderHighlight Directory
call <sid>hi('NeogitDiffContextHighlight',  s:gui03, s:guibg, s:cterm03, s:ctermbg, 'italic', '')
call <sid>hi('NeogitDiffContextCursor',     '', s:guibg, "", s:ctermbg, 'italic', '')
hi! link NeogitDiffAddHighlight Added
hi! link NeogitDiffDeleteHighlight Removed

hi! link NeogitHunkHeaderCursor Special
hi! link NeogitDiffHeaderCursor Directory
hi! link NeogitDiffAddCursor Added
hi! link NeogitDiffDeleteCursor Removed

" PHP
call <sid>hi('phpMemberSelector', s:gui05, '', s:cterm05, '', '', '')
call <sid>hi('phpComparison',     s:gui05, '', s:cterm05, '', '', '')
call <sid>hi('phpParent',         s:gui05, '', s:cterm05, '', '', '')
call <sid>hi('phpMethodsVar',     s:gui0C, '', s:cterm0C, '', '', '')

" Python
call <sid>hi('pythonOperator',  s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('pythonRepeat',    s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('pythonInclude',   s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('pythonStatement', s:gui0E, '', s:cterm0E, '', '', '')

" Ruby
call <sid>hi('rubyAttribute',              s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('rubyConstant',               s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('rubyInterpolationDelimiter', s:gui0F, '', s:cterm0F, '', '', '')
call <sid>hi('rubyRegexp',                 s:gui0C, '', s:cterm0C, '', '', '')
call <sid>hi('rubySymbol',                 s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('rubyStringDelimiter',        s:gui0B, '', s:cterm0B, '', '', '')

" SASS
call <sid>hi('sassidChar',    s:gui08, '', s:cterm08, '', '', '')
call <sid>hi('sassClassChar', s:gui09, '', s:cterm09, '', '', '')
call <sid>hi('sassInclude',   s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('sassMixing',    s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('sassMixinName', s:gui0D, '', s:cterm0D, '', '', '')

" Java
call <sid>hi('javaOperator', s:gui0D, '', s:cterm0D, '', '', '')

" Plugins

" Clap
hi! link ClapInput             ColorColumn
hi! link ClapSpinner           ColorColumn
hi! link ClapDisplay           Default
hi! link ClapPreview           ColorColumn
hi! link ClapCurrentSelection  CursorLine
hi! link ClapNoMatchesFound    ErrorFloat

" Coc
hi! link CocErrorSign         DiagnosticError
hi! link CocWarningSign       DiagnosticWarn
hi! link CocInfoSign          DiagnosticInfo
hi! link CocHintSign          DiagnosticHint

hi! link CocErrorFloat        DiagnosticFloatingError
hi! link CocWarningFloat      DiagnosticFloatingWarn
hi! link CocInfoFloat         DiagnosticFloatingInfo
hi! link CocHintFloat         DiagnosticFloatingHint

hi! link CocErrorHighlight    DiagnosticError
hi! link CocWarningHighlight  DiagnosticWarn
hi! link CocInfoHighlight     DiagnosticInfo
hi! link CocHintHighlight     DiagnosticHint

hi! link CocSem_angle             Keyword
hi! link CocSem_annotation        Keyword
hi! link CocSem_attribute         Type
hi! link CocSem_bitwise           Keyword
hi! link CocSem_boolean           Boolean
hi! link CocSem_brace             Normal
hi! link CocSem_bracket           Normal
hi! link CocSem_builtinAttribute  Type
hi! link CocSem_builtinType       Type
hi! link CocSem_character         String
hi! link CocSem_class             Structure
hi! link CocSem_colon             Normal
hi! link CocSem_comma             Normal
hi! link CocSem_comment           Comment
hi! link CocSem_comparison        Keyword
hi! link CocSem_concept           Keyword
hi! link CocSem_constParameter    Identifier
hi! link CocSem_dependent         Keyword
hi! link CocSem_dot               Keyword
hi! link CocSem_enum              Structure
hi! link CocSem_enumMember        Constant
hi! link CocSem_escapeSequence    Type
hi! link CocSem_event             Identifier
hi! link CocSem_formatSpecifier   Type
hi! link CocSem_function          Function
hi! link CocSem_interface         Type
hi! link CocSem_keyword           Keyword
hi! link CocSem_label             Keyword
hi! link CocSem_logical           Keyword
hi! link CocSem_macro             Macro
hi! link CocSem_method            Function
hi! link CocSem_modifier          Keyword
hi! link CocSem_namespace         Identifier
hi! link CocSem_number            Number
hi! link CocSem_operator          Operator
hi! link CocSem_parameter         Identifier
hi! link CocSem_parenthesis       Normal
hi! link CocSem_property          Identifier
hi! link CocSem_punctuation       Keyword
hi! link CocSem_regexp            Type
hi! link CocSem_selfKeyword       Constant
hi! link CocSem_semicolon         Normal
hi! link CocSem_string            String
hi! link CocSem_struct            Structure
hi! link CocSem_type              Type
hi! link CocSem_typeAlias         Type
hi! link CocSem_typeParameter     Type
hi! link CocSem_unknown           Normal
hi! link CocSem_variable          Identifier

call <sid>hi('CocHighlightRead',   s:gui0B, s:gui01,  s:cterm0B, s:cterm01, '', '')
call <sid>hi('CocHighlightText',   s:gui0A, s:gui01,  s:cterm0A, s:cterm01, '', '')
call <sid>hi('CocHighlightWrite',  s:gui08, s:gui01,  s:cterm08, s:cterm01, '', '')
call <sid>hi('CocListMode',        s:gui01, s:gui0B,  s:cterm01, s:cterm0B, 'bold', '')
call <sid>hi('CocListPath',        s:gui01, s:gui0B,  s:cterm01, s:cterm0B, '', '')
call <sid>hi('CocSessionsName',    s:gui05, '', s:cterm05, '', '', '')

" fugtive
hi link diffAdded GitAddSign
hi link diffChanged GitChangeSign
hi link diffRemoved GitDeleteSign

" CMP
" https://microsoft.github.io/language-server-protocol/specifications/lsp/3.18/specification/#completionItemKind
if has('nvim-0.8.0')
  hi! link CmpItemAbbrDeprecated    Deprecated
  hi! link CmpItemAbbrMatch         PMenuMatch
  hi! link CmpItemAbbrMatchFuzzy    PMenuMatch
  hi! link CmpItemKindClass         @lsp.type.class
  hi! link CmpItemKindColor         @lsp.type.keyword
  hi! link CmpItemKindConstant      @constant
  hi! link CmpItemKindConstructor   @constructor
  hi! link CmpItemKindEnum          @lsp.type.enum
  hi! link CmpItemKindEnumMember    @lsp.type.enumMember
  hi! link CmpItemKindEvent         @lsp.type.event
  hi! link CmpItemKindField         @lsp.type.property
  hi! link CmpItemKindFile          @string.special.path
  hi! link CmpItemKindFolder        @string.special.path
  hi! link CmpItemKindFunction      @lsp.type.function
  hi! link CmpItemKindInterface     @lsp.type.interface
  hi! link CmpItemKindKeyword       @lsp.type.keyword
  hi! link CmpItemKindMethod        @lsp.type.method
  hi! link CmpItemKindModule        @lsp.type.namespace
  hi! link CmpItemKindOperator      @lsp.type.operator
  hi! link CmpItemKindProperty      @lsp.type.property
  hi! link CmpItemKindReference     @lsp.type.variable
  hi! link CmpItemKindSnippet       @lsp.type.string
  hi! link CmpItemKindStruct        @lsp.type.struct
  hi! link CmpItemKindText          @lsp.type.string
  hi! link CmpItemKindTypeParameter @lsp.type.typeParameter
  hi! link CmpItemKindUnit          @lsp.type.namespace
  hi! link CmpItemKindValue         @constant
  hi! link CmpItemKindVariable      @lsp.type.variable
endif

" GitGutter
hi! link GitGutterAdd          GitAddSign
hi! link GitGutterChange       GitChangeSign
hi! link GitGutterDelete       GitDeleteSign
hi! link GitGutterChangeDelete GitChangeDeleteSign

" indent-blankline
if has('nvim')
  call <sid>hi('@ibl.indent.char', s:gui01, '', s:cterm01, '', '', '')
endif

" pangloss/vim-javascript
call <sid>hi('jsOperator',          s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('jsStatement',         s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('jsReturn',            s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('jsThis',              s:gui08, '', s:cterm08, '', '', '')
call <sid>hi('jsClassDefinition',   s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('jsFunction',          s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('jsFuncName',          s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('jsFuncCall',          s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('jsClassFuncName',     s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('jsClassMethodType',   s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('jsRegexpString',      s:gui0C, '', s:cterm0C, '', '', '')
call <sid>hi('jsGlobalObjects',     s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('jsGlobalNodeObjects', s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('jsExceptions',        s:gui0A, '', s:cterm0A, '', '', '')
call <sid>hi('jsBuiltins',          s:gui0A, '', s:cterm0A, '', '', '')

" Matchup
call <sid>hi('MatchWord', s:gui0B, s:gui01,  s:cterm0B, s:cterm01, 'underline', '')

" NERDTree
call <sid>hi('NERDTreeDirSlash', s:gui0D, '', s:cterm0D, '', '', '')
call <sid>hi('NERDTreeExecFile', s:gui05, '', s:cterm05, '', '', '')

" Signify
hi! link SignifySignAdd    GitAddSign
hi! link SignifySignChange GitChangeSign
hi! link SignifySignDelete GitDeleteSign

" Startify
call <sid>hi('StartifyBracket', s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('StartifyFile',    s:gui07, '', s:cterm07, '', '', '')
call <sid>hi('StartifyFooter',  s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('StartifyHeader',  s:gui0B, '', s:cterm0B, '', '', '')
call <sid>hi('StartifyNumber',  s:gui09, '', s:cterm09, '', '', '')
call <sid>hi('StartifyPath',    s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('StartifySection', s:gui0E, '', s:cterm0E, '', '', '')
call <sid>hi('StartifySelect',  s:gui0C, '', s:cterm0C, '', '', '')
call <sid>hi('StartifySlash',   s:gui03, '', s:cterm03, '', '', '')
call <sid>hi('StartifySpecial', s:gui03, '', s:cterm03, '', '', '')

" Remove functions
delf <sid>hi

" Remove color variables
unlet s:gui00 s:gui01 s:gui02 s:gui03 s:gui04 s:gui05 s:gui06 s:gui07 s:gui08 s:gui09 s:gui0A s:gui0B s:gui0C s:gui0D s:gui0E s:gui0F s:guibg s:gui10 s:gui11 s:gui12 s:gui13 s:gui14 s:gui15 s:gui16 s:gui17
unlet s:cterm00 s:cterm01 s:cterm02 s:cterm03 s:cterm04 s:cterm05 s:cterm06 s:cterm07 s:cterm08 s:cterm09 s:cterm0A s:cterm0B s:cterm0C s:cterm0D s:cterm0E s:cterm0F s:ctermbg s:cterm10 s:cterm11 s:cterm12 s:cterm13 s:cterm14 s:cterm15 s:cterm16 s:cterm17
