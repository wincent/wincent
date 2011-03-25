" based on MacVim colorscheme

highlight clear

" Reset String -> Constant links etc if they were reset
if exists("syntax_on")
  syntax reset
endif

let colors_name = "wincent"

" `:h highlight-groups`
hi Boolean      gui=NONE guifg=Red3 guibg=NONE
hi Comment      gui=italic guifg=Blue2 guibg=NONE
hi Constant     gui=NONE guifg=DarkOrange guibg=NONE
hi Cursor       guibg=fg guifg=bg
hi CursorColumn guibg=#F1F5FA
hi CursorIM     guibg=fg guifg=bg
hi CursorLine   guibg=#F1F5FA
hi DiffAdd      guibg=MediumSeaGreen
hi DiffChange   guibg=DeepSkyBlue
hi DiffDelete   gui=bold guifg=Black guibg=SlateBlue
hi DiffText     gui=NONE guibg=Gold
hi Directory    guifg=#1600FF
hi ErrorMsg     guibg=Firebrick2 guifg=White
hi FoldColumn   guibg=Grey guifg=DarkBlue
hi Folded       guibg=#E6E6E6 guifg=DarkBlue
hi IncSearch    gui=reverse
hi LineNr       guifg=#888888 guibg=#E6E6E6
hi MatchParen   guifg=White guibg=MediumPurple1
hi ModeMsg      gui=bold
hi MoreMsg      gui=bold guifg=SeaGreen4
hi NonText      guifg=Grey
hi Pmenu        guibg=LightSteelBlue1
hi PmenuSbar    guibg=Grey
hi PmenuSel     guifg=White guibg=SkyBlue4
hi PmenuThumb   gui=reverse
hi Question     gui=bold guifg=Chartreuse4
hi Search       guibg=CadetBlue1 guifg=NONE
hi SignColumn   guibg=Grey guifg=DarkBlue
hi SpecialKey   guifg=Blue
hi SpellBad     guisp=Firebrick2 gui=undercurl
hi SpellCap     guisp=Blue gui=undercurl
hi SpellLocal   guisp=DarkCyan gui=undercurl
hi SpellRare    guisp=Magenta gui=undercurl
hi Statement    gui=bold guifg=Maroon guibg=NONE
hi StatusLine   gui=NONE guifg=White guibg=DarkSlateGray
hi StatusLineNC gui=NONE guifg=SlateGray guibg=Gray80
hi TabLine      gui=underline guibg=LightGrey
hi TabLineFill  gui=reverse
hi TabLineSel   gui=bold
hi Title        gui=bold guifg=DeepSkyBlue3
hi Todo         gui=NONE guifg=DarkGreen guibg=PaleGreen1
hi Type         gui=bold guifg=Green4 guibg=NONE
hi VertSplit    gui=NONE guifg=DarkSlateGray guibg=Gray90
hi WarningMsg   guifg=Firebrick2
hi WildMenu     guibg=SkyBlue guifg=Black
hi lCursor      guibg=fg guifg=bg
if has("gui_macvim")
  hi Normal       gui=NONE guifg=MacTextColor guibg=#FFFFC6
  hi Visual       guibg=MacSelectedTextBackgroundColor
else
  hi Normal       gui=NONE guifg=Black guibg=White
  hi Visual       guibg=#72F7FF
endif

" custom additions
hi LineProximity guibg=#DDDDB6
hi LineOverflow guibg=#AAAAB6
hi LineHardLimit guifg=White guibg=Red

" Syntax items (`:he group-name` -- more groups are available, these are just
" the top level syntax items for now).
hi Error        gui=NONE guifg=White guibg=Firebrick3
hi Identifier   gui=NONE guifg=Aquamarine4 guibg=NONE
hi Ignore       gui=NONE guifg=bg guibg=NONE
hi PreProc      gui=NONE guifg=DodgerBlue3 guibg=NONE
hi Special      gui=NONE guifg=BlueViolet guibg=NONE
hi String       gui=NONE guifg=SkyBlue4 guibg=NONE
hi Underlined   gui=underline guifg=SteelBlue1

"
" Change the selection color on focus change
"
if has("gui_macvim") && !exists("s:augroups_defined")
  au FocusLost * if exists("colors_name") | hi Visual guibg=MacSecondarySelectedControlColor | endif
  au FocusGained * if exists("colors_name") | hi Visual guibg=MacSelectedTextBackgroundColor | endif
  let s:augroups_defined = 1
endif
