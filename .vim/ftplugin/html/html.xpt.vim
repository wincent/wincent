if exists("b:__HTML_HTML_XPT_VIM__")
  finish
endif
let b:__HTML_HTML_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" constant definition
call extend(s:v, {'\$TRUE': '1', '\$FALSE' : '0', '\$NULL' : 'NULL', '\$UNDEFINED' : ''})

" inclusion
XPTinclude 
      \ _common/common
      \ _comment/xml
      \ xml/xml
      \ xml/wrap
" ========================= Function and Varaibles =============================
fun! s:f.createTable(...) "{{{
  let nrow_str = inputdialog("num of row:")
  let nrow = nrow_str + 0

  let ncol_str = inputdialog("num of column:")
  let ncol = ncol_str + 0
  

  let l = ""
  let i = 0 | while i < nrow | let i += 1
    let j = 0 | while j < ncol | let j += 1
      let l .= "<tr>\n<td id=\"`pre^_".i."_".j."\"></td>\n</tr>\n"
    endwhile
  endwhile
  return "<table id='`id^'>\n".l."</table>"

endfunction "}}}


" ================================= Snippets ===================================
call XPTemplatePriority('lang')
call XPTemplate('doctype_html3', [
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">'])
call XPTemplate('doctype_html4_frameset', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Frameset//EN" "http://www.w3.org/TR/REC-html40/frameset.dtd">'])
call XPTemplate('doctype_html4_loose', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">'])
call XPTemplate('doctype_html4_strict', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">'])
call XPTemplate('doctype_html41_frameset', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">'])
call XPTemplate('doctype_html41_loose', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'])
call XPTemplate('doctype_html41_strict', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">'])
call XPTemplate('doctype_xthml1_frameset', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">'])
call XPTemplate('doctype_xhtml1_strict', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'])
call XPTemplate('doctype_xhtml1_transitional', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'])
call XPTemplate('doctype_xhtml11', [ 
      \'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/1999/xhtml">'])

call XPTemplate("id", {'syn' : 'tag'}, 'id="`^"')
call XPTemplate("class", {'syn' : 'tag'}, 'class="`^"')
call XPTemplate('a', '<a href="`href^">`cursor^</a>')
call XPTemplate("script", [ '<script language="javascript" type="text/javascript">', '`cursor^', '</script>'])
call XPTemplate("scrlink", [ '<script language="javascript" type="text/javascript" src="`cursor^"></script>'])


call XPTemplate('table', [ '`createTable()^' ])
call XPTemplate('table2', [
      \ '<table>',
      \ '  <tr>',
      \ '    <td>`text^^</td>`...2^', 
      \ '    <td>`text^^</td>`...2^', 
      \ '  </tr>`...0^', 
      \ '  <tr>',
      \ '    <td>`text^^</td>`...1^', 
      \ '    <td>`text^^</td>`...1^', 
      \ '  </tr>`...0^', 
      \ '</table>'
      \])

call XPTemplate('table3', [
      \ '<table id="`id^">`CntStart("i", "0")^',
      \ '  <tr>`CntStart("j", "0")^',
      \ '    <td id="`^R("id")_{Cnt("i")}_{CntIncr("j")}^">`text^^</td>`...2^', 
      \ '    <td id="`^R("id")_{Cnt("i")}_{CntIncr("j")}^">`text^^</td>`...2^', 
      \ '  </tr>`tr...^', 
      \ '  <tr>',
      \ '    <td id="\`\^CntStart("j","0")R("id")_{CntIncr("i")}_{CntIncr("j")}\^">\`text\^\^</td>\`td...\^', 
      \ '    <td id="\\\`\\\^R("id")_{Cnt("i")}_{CntIncr("j")}\\\^">\\\`text\\\^\\\^</td>\\\`td...\\\^\^\^', 
      \ '  </tr>\`tr...\^^^', 
      \ '</table>'
      \])

XPTemplateDef

XPT html hint=<html><head>..<head><body>...
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=`encoding^utf-8^"/>
    <link rel="stylesheet" type="text/css" href="" />
    <style></style>
    <title>`title^E('%:r')^</title>
    <script language="javascript" type="text/javascript">
      <!-- -->
    </script>
  </head>
  <body>
    `cursor^
  </body>
</html>


XPT div hint=<div>\ ..\ </div>
<div`^>`cursor^</div>


XPT p hint=<p>\ ..\ </p>
<p`^>`cursor^</p>


XPT br hint=<br\ />
<br/>


" <h1>`cr^^`cursor^`cr^^</h1>
XPT h hint=<h?>\ ..\ <h?>
XSET n=1
<h`n^>`cursor^</h`n^>




XPT p_ hint=
<p>`wrapped^</p>

XPT div_ hint=
<div>`wrapped^</div>

XPT h_ hint=<h?>\ ..\ </h?>
XSET n=1
<h`n^>`wrapped^</h`n^>



XPT a_ hint=<a\ href="">\ SEL\ </a>
<a href="">`wrapped^</a>


