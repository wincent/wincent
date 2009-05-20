if exists("b:__XML_WRAP_XPT_VIM__")
    finish
endif
let b:__XML_WRAP_XPT_VIM__= 1


" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
call XPTemplatePriority('spec')
XPTemplateDef
XPT _ hint=<Tag>\ SEL\ </Tag>
<`tag^`...^ `name^="`val^"`...^>`wrapped^</`tag^>


XPT CDATA_ hint=<![CDATA[\ SEL\ ]]>
<![CDATA[
`wrapped^
]]>


