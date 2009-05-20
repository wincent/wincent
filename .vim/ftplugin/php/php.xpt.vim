if exists("b:__PHP_XPT_VIM__")
    finish
endif
let b:__PHP_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

call extend(s:v, { '$TRUE': 'true'
                \, '$FALSE' : 'false'
                \, '$BRACKETSTYLE' : "\n"
                \, '$NULL' : 'NULL'
                \})
" inclusion
XPTinclude
      \ _common/common
      \ _condition/c.like
      \ _loops/c.like

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
" Based on snipmate's php templates
XPTemplateDef
XPT while hint=while\ (\ ..\ )\ {\ ..\ }
while (`cond^)
{
    `body^
}


XPT for hint=for\ (..;..;++)
for ($`var^i^ = `init^; $`var^ < `val^; $`var^++)
{
    `cursor^
}



XPT forr hint=for\ (..;..;--)
for ($`var^i^ = `init^; $`var^ >= `val^0^; $`var^--)
{
    `cursor^
}


XPT foreach hint=foreach\ (..\ as\ ..)\ {..}
foreach ($`var^ as `container^)
{
    `body^
}


XPT fun hint=function\ ..(\ ..\ )\ {..}
function `funName^( `params^ )
{
   `cursor^
}


XPT class hint=class\ ..\ {\ ..\ }
class `className^
{
    function __construct( `args^ )
    {
        `cursor^
    }
}



XPT interface hint=interface\ ..\ {\ ..\ }
interface `interfaceName^
{
    `cursor^
}


