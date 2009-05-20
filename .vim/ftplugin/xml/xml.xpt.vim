if exists("b:__XML_XPT_VIM__")
    finish
endif
let b:__XML_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
call XPTemplatePriority('spec')
XPTemplateDef
XPT t hint=<Tag>..</Tag>
<`tag^`...^ `name^="`val^"`...^>
    `cursor^
</`tag^>


XPT ver hint=<?xml\ version=...
<?xml version="`ver^1.0^" encoding="`enc^utf-8^" ?>


XPT style hint=<?xml-stylesheet...
<?xml-stylesheet type="`style^text/css^" href="`from^">


XPT CDATA_ hint=<![CDATA[...
<![CDATA[
`cursor^
]]>


