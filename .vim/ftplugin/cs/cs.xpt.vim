if exists('b:__CS_XPT_VIM__')
  finish
endif
let b:__CS_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

call extend(s:v, { '$TRUE': 'true'
                \, '$FALSE' : 'false'
                \, '$NULL' : 'null'
                \, '$UNDEFINED' : ''
                \, '$BRACKETSTYLE' : "\n"
                \, '$INDENT_HELPER' : ';' })
" inclusion
XPTinclude 
      \ _common/common
      \ _comment/c.like
      \ _condition/c.like
      \ _loops/c.like
      \ _loops/java.like
      \ c/wrap

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef

XPT foreach hint=foreach\ (..\ in\ ..)\ {..}
foreach ( `var^ `e^ in `what^ )
{
    `cursor^
}


XPT enum hint=enum\ {\ ..\ }
enum `enumName^
{
    `elem^`...^,
    `subElem^`...^
};
`cursor^


XPT struct hint=struct\ {\ ..\ }
`access^public^ struct `structName^
{
    `fieldAccess^public^ `type^ `name^;`...^
    `fieldAccess^public^ `type^ `name^;`...^
}


XPT class hint=class\ +ctor
class `className^
{
    public `className^( `ctorParam^^ )
    {
        `cursor^
    }
}


XPT main hint=static\ main\ string[]
public static void Main( string[] args )
{
    `cursor^
}


XPT prop hint=..\ ..\ {get\ set}
public `type^ `Name^
{`get...^
    get { return \`what\^; }^^`set...^
    set { \`what\^ = value; }^^
}


XPT namespace hint=namespace\ {}
namespace `name^
{
    `cursor^
}


XPT try hint=try\ ..\ catch\ ..\ finally
try
{
    `what^
}`...^
catch (`except^ e)
{
    `handler^
}`...^`catch...^
catch
{
    \`_\^
}^^`finally...^
finally
{
    \`cursor\^
}^^



