if exists("b:__JAVA_XPT_VIM__")
  finish
endif
let b:__JAVA_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, { '$TRUE': 'true'
               \ , '$FALSE' : 'false'
               \ , '$NULL' : 'null'
               \ , '$UNDEFINED' : ''
               \ , '$BRACKETSTYLE' : ''
               \ , '$INDENT_HELPER' : ';'})

" inclusion
XPTinclude 
      \ _common/common
      \ _comment/c.like
      \ _condition/c.like
      \ _loops/java.like
      \ _loops/c.like
      \ c/wrap

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef

XPT foreach hint=for\ \(\ ..\ :\ ..\ \)
for ( `type^ `var^ : `inWhat^ ) {
    `cursor^
}


XPT private hint=private\ ..\ ..
private `type^ `varName^;

XPT public hint=private\ ..\ ..
public `type^ `varName^;

XPT protected hint=private\ ..\ ..
protected `type^ `varName^;

XPT class hint=class\ ..\ ctor
public class `className^ {
    public `className^( `ctorParam^^ ) {
        `cursor^
    }
}


XPT main hint=main\ (\ String\ )
public static void main( String[] args )
{
    `cursor^
}


XPT enum hint=public\ enum\ {\ ..\ }
`access^public^ enum `enumName^
{
    `elem^`...^,
    `subElem^`...^
};
`cursor^

XPT prop hint=var\ getVar\ ()\ setVar\ ()
`type^ `varName^;

`get...^public \`R("type")\^ get\`S(R("varName"),".",'\\u&',"")\^()
    { return \`R("varName")\^; }^^

`set...^public void set\`S(R("varName"),".",'\\u&',"")\^( \`R("type")\^ val )
    { \`R("varName")\^ = val; }^^


XPT try hint=try\ ..\ catch\ (..)\ ..\ finally
try
{
    `what^
}`...^
catch (`except^ e)
{
    `handler^
}`...^
`catch...^catch (Exception e)
{
    \`\^
}^^
`finally...^finally
{
    \`cursor\^
}^^



