syntax match TemplateMark /`\|\^/ contained
syntax match TemplateItem /`.\{-}\^/ contains=TemplateMark containedin=ALL
syntax match TemplateLine /^XPT\s\+.*$/ containedin=ALL


syntax keyword TemplateKey XPT XSET XSETm indent hint syn priority containedin=TemplateLine
" syntax match TemplateName /^XPT\s\+\w\+/ containedin=TemplateLine

hi XPTregion ctermbg=yellow
hi TemplateItem gui=none guifg=#5f4511 guibg=#efdfc1
hi TemplateMark gui=none guifg=#bfb39b guibg=#efdfc1
hi TemplateKey cterm=none ctermfg=red gui=none guifg=brown
" hi TemplateName cterm=none ctermfg=green gui=none guifg=green
