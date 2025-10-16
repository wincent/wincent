source <sfile>:p:h/include/yaml.vim


syn keyword booleanStuff    true True TRUE false False FALSE yes Yes YES no No NO on On ON off Off OFF
syn match userVariable '\w*='
syn match ansibleVars 'ansible_\w*='
syn match hostBlocks '\[.*\]'

hi def link ansibleVars     Type
hi def link hostBlocks      Operator
hi def link userVariable    Statement
hi def link booleanStuff    Boolean
