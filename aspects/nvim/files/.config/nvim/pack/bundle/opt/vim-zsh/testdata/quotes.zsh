# Test quoting.

 'single'   'var: $var'   'subst: $(ls)'   'esc: \n \x01 \001'
 "double"   "var: $var"   "subst: $(ls)"   "esc: \n \x01 \001"
$'single'  $'var: $var'  $'subst: $(ls)'  $'esc: \n \x01 \001'
 `batick`   `var: $var`   `subst: $(ls)`   `esc: \n \x01 \001`

"'nest'" "`nest`"
'"nest"' '`nest`'

 "escape: \" \' \` \\ escape"
 'escape: \" \' \` \\ escape'
$'escape: \" \' \` \\ escape'
