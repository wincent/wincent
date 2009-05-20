if exists("b:__STRUCTURES_C_LIKE_XPT_VIM__") 
    finish 
endif
let b:__STRUCTURES_C_LIKE_XPT_VIM__ = 1 

" containers
let [s:f, s:v] = XPTcontainer() 

" constant definition
call extend(s:v, {'$TRUE': '1', '$FALSE' : '0', '$NULL' : 'NULL', '$INDENT_HELPER' : '/* void */;'}, 'keep')

" inclusion
XPTemplateDef

XPT enum hint=enum\ {\ ..\ }
enum `enumName^
{
    `elem^`
    `...^,
    `subElem^`
    `...^
} `var^^;


XPT struct hint=struct\ {\ ..\ }
struct `structName^
{
    `type^ `field^;`
    `...^
    `type^ `field^;`
    `...^
} `var^^;


XPT bitfield hint=struct\ {\ ..\ :\ n\ }
struct `structName^
{
    `type^ `field^ : `bits^;`
    `...^
    `type^ `field^ : `bits^;`
    `...^
} `var^^;


