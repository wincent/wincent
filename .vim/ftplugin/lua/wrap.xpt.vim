if exists("b:__LUA_WRAP_XPT_VIM__")
    finish
endif
let b:__LUA_WRAP_XPT_VIM__ = 1


XPTinclude
      \ _common/common
"================ Wrapped Items ================"
XPTemplateDef

XPT comment_ hint=--\ SEL
-- `wrapped^

XPT invoke_ hint=..(SEL)
`name^(`wrapped^)

