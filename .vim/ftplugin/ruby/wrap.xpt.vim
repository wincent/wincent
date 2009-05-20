if exists("b:__RUBY_WRAP_XPT_VIM__")
    finish
endif
let b:__RUBY_WRAP_XPT_VIM__ = 1


XPTinclude
      \ _common/common
"================ Wrapped Items ================"
XPTemplateDef

XPT invoke_ hint=..(SEL)
XSET name.post=RubySnakeCase()
`name^(`wrapped^)


XPT def_ hint=def\ ..()\ SEL\ end
XSET _.post=RubySnakeCase()
def `_^`(`args`)^
`wrapped^
end


XPT class_ hint=class\ ..\ SEL\ end
XSET _.post=RubyCamelCase()
class `_^
`wrapped^
end


XPT module_ hint=module\ ..\ SEL\ end
XSET _.post=RubyCamelCase()
module `_^
`wrapped^
end


XPT begin_ hint=begin\ SEL\ rescue\ ...
XSET exception=Exception
XSET block=# block
XSET rescue...|post=\nrescue `exception^\n  `block^`\n`rescue...^
XSET else...|post=\nelse\n  `block^
XSET ensure...|post=\nensure\n  `cursor^
begin
`wrapped^`
`rescue...^`
`else...^`
`ensure...^
end
