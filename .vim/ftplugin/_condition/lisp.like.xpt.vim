if exists("b:___CONDITION_C_LIKE_XPT_VIM__")
  finish
endif
let b:___CONDITION_C_LIKE_XPT_VIM__ = 1

call XPTemplatePriority('like')

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef

XPT if hint=(if\ (then)\ (else))
(if [`condition^]
    (`then^)
    `else...^\(\`cursor\^\)^^)

XPT when hint=(when\ cond\ ..)
(when (`cond^)
   (`todo0^) `...^
   (`todon^)`...^)


XPT unless hint=(unless\ cond\ ..)
(unless (`cond^)
   (`todo0^) `...^
   (`todon^)`...^)

