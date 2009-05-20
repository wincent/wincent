if exists("b:__PS1_XPT_VIM__")
    finish
endif
let b:__PS1_XPT_VIM__ = 1


" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common
      \ _condition/perl.like

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef
XPT cmdlet hint=cmdlet\ ..-..\ {}
Cmdlet `verb^-`noun^
{
    `Param...^Param\(
       \`\^
    \)^^
    `Begin...^Begin
    {
    }^^
    Process
    {
    }
    `End...^End
    {
    }^^
}



XPT fun hint=function\ ..(..)\ {\ ..\ }
function `funName^( `params^ )
{
   `cursor^
}


XPT function hint=function\ {\ BEGIN\ PROCESS\ END\ }
function `funName^( `params^ )
{
    `Begin...^Begin
    {
        \`\^
    }^^
    `Process...^Process
    {
        \`\^
    }^^
    `End...^End
    {
        \`\^
    }^^
}


XPT foreach hint=foreach\ (..\ in\ ..)
foreach ($`var^ in `other^)
    { `cursor^ }


XPT switch hint=switch\ (){\ ..\ {..}\ }
switch `option^^ (`what^)
{
 `pattern^ { `action^ }`...^
 `pattern^ { `action^ }`...^
 `Default...^Default { \`action\^ }^^
}


XPT trap hint=trap\ [..]\ {\ ..\ }
trap [`exception^Exception^]
{
    `body^
}


XPT for hint=for\ (..;..;++)
for ($`var^i^ = `init^; $`var^ -ge `val^; $`var^--)
{
    `cursor^
}


XPT forr hint=for\ (..;..;--)
for ($`var^i^ = `init^; $`var^ -ge `val^; $`var^--)
{
    `cursor^
}


