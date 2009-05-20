XPTemplate priority=lang 


XPTvar $TRUE          1
XPTvar $FALSE         0
XPTvar $NULL          NULL
XPTvar $INDENT_HELPER /* void */;


XPTinclude
      \ _common/common 
      \ _comment/c.like 
      \ _condition/c.like
      \ _loops/c.like
      \ _structures/c.like
      \ _preprocessor/c.like


" ========================= Function and Varaibles =============================

let s:f = XPTcontainer()[ 0 ]

function! s:f.showLst()
   return [ "xx-small", "x-small", "small", "medium", "large", "x-large", "xx-large", "larger", "smaller" ]
endfunction

" ================================= Snippets ===================================
XPTemplateDef


" XPT fs
" font-size: `--`size`==^showLst()^
" `size^
" ..XPT
" 
" XPT tt
" XSET to=Trigger("fs")
" "`~~~`to`***^"
" ..XPT
" 
" XPT yy
" `-`w`=^~NN()~^
" ..XPT


" " sample:
" XPT for indent=/2*8 hint=this\ is\ for
" for (`i^ = 0; `i^ < `len^; ++`i^) {
"   `cursor^
" }


" " JUST A TEST
" "
" " Super Repetition. saves 1 key pressing. without needing expanding repetition
" " For small repetition usage. Such as parameter list
" " 
" "   type first, then <tab>
" " NOT <tab> then type
" "
" " NOTE that "exp" followed by only 2 dot. distinction from normal
" " expandable. For normal expandable does not evaluate expression.
" "
" XPT superrepetition
" XSET exp..|post=ExpandIfNotEmpty(', ', 'exp..')
" `exp..^




XPT assert	hint=assert\ (..,\ msg)
assert(`isTrue^, "`text^");

XPT main hint=main\ (argc,\ argv)
  int
main(int argc, char **argv)
{
  `cursor^
  return 0;
}

" Quick-Repetition parameters list
XPT fun		hint=func..\ (\ ..\ )\ {...
XSET p..|post=ExpandIfNotEmpty(', ', 'p..')
  `int^
`name^(`p..^)
{
  `cursor^
}

XPT cmt
/**
 * @author : `$author^ | `$email^
 * @description
 *     `cursor^
 * @return {`int^} `desc^
 */


XPT para syn=comment	hint=comment\ parameter
@param {`Object^} `name^ `desc^


XPT filehead
/**-------------------------/// `sum^ \\\---------------------------
 *
 * <b>`function^</b>
 * @version : `1.0^
 * @since : `strftime("%Y %b %d")^
 * 
 * @description :
 *   `cursor^
 * @usage : 
 * 
 * @author : `$author^ | `$email^
 * @copyright `.com.cn^ 
 * @TODO : 
 * 
 *--------------------------\\\ `sum^ ///---------------------------*/

