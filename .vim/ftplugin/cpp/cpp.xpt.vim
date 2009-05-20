if exists("b:__CPP_CPP_XPT_VIM__")
  finish
endif
" To avoid loading the C version...
let b:__C_C_XPT_VIM__ = 1
let b:__CPP_CPP_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()


call extend(s:v, { '$TRUE': 'true'
                \, '$FALSE' : 'false'
                \, '$NULL' : 'NULL'
                \, '$UNDEFINED' : ''
                \, '$BRACKETSTYLE' : "\n"
                \, '$INDENT_HELPER' : ';' }, 'force')

" inclusion
XPTinclude
      \ _common/common
      \ _comment/c.like
      \ _condition/c.like
      \ _loops/c.like
      \ _loops/java.like
      \ _structures/c.like
      \ _preprocessor/c.like
      \ c/wrap

" ========================= Function and Varaibles =============================
function! s:f.cleanTempl( ctx, ... )
  let notypename = substitute( a:ctx,"\\s*typename\\s*","","g" )
  let cleaned = substitute( notypename, "\\s*class\\s*", "", "g" )
  return cleaned
endfunction


" ================================= Snippets ===================================
XPTemplateDef

XPT all  hint=stl\ begin..end
`v^.begin(), `v^.end(), `cursor^
 

XPT class   hint=class+ctor
class `className^
{
public:
    `className^( `ctorParam^ );
    ~`className^();
    `className^( const `className^ &cpy );
    `cursor^
private:
};
 
// Scratch implementation
// feel free to copy/paste or destroy
`className^::`className^( `ctorParam^ )
{
}
 
`className^::~`className^()
{
}
 
`className^::`className^( const `className^ &cpy )
{
}


XPT fun=..\ ..\ (..)
`int^ `name^(`_^^)
{
    `cursor^
}


XPT inf hint=open\ input.txt\ and\ iitr
ifstream inf("`input.txt^",ios_base::in);
istreambuf_iterator `string^ iitr(`inf^);


XPT namespace hint=namespace\ {}
namespace `name^
{
    `cursor^
}


XPT main hint=main\ (argc,\ argv)
int main(int argc, char *argv[])
{
    `cursor^
    return 0;
}


"all STL headers and namespace std
XPT stl hint=STL\ headers\ and\ namespace\ std
#include <iostream>
#include <ios>
#include <fstream>
#include <iterator>  //required for istream_iterator
#include <list>
#include <vector>
#include <algorithm>
#include <cassert>
#include <string>
#include <stdexcept> //-- for out_of_range definition

using namespace std;


XPT templateclass   hint=template\ <>\ class
template
    <`templateParam^>
class `className^
{
public:
    `className^( `ctorParam^ );
    ~`className^();
    `className^( const `className^ &cpy );
    `cursor^
private:
};
 
// Scratch implementation
// feel free to copy/paste or destroy
template <`templateParam^>
`className^<`_^cleanTempl(R('templateParam'))^^>::`className^( `ctorParam^ )
{
}
 
template <`templateParam^>
`className^<`_^cleanTempl(R('templateParam'))^^>::~`className^()
{
}
 
template <`templateParam^>
`className^<`_^cleanTempl(R('templateParam'))^^>::`className^( const `className^ &cpy )
{
}


XPT try hint=try\ ...\ catch...
try
{
    `what^
}`...^
catch ( `except^ )
{
    `handler^
}`...^
`catch...^catch ( ... )
{
    \`cursor\^
}^^


