if exists('b:__SCHEME_XPT_VIM__')
  finish
endif
let b:__SCHEME_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common
      \ _condition/lisp.like

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef
XPT begin hint=(begin\ ..\ )
(begin
   (`todo0^) `...^
   (`todon^)`...^)


XPT case hint=(case\ (of)\ ((match)\ (expr))\ ..)
(case (`of^)
      ({`match^} `expr1^) `...^
      ({`matchn^} `exprn^)`...^
      `else...^\(else \`cursor\^\)^^)



XPT cond hint=(cond\ ([condi]\ (expr))\ ..)
(cond ([`condition^] `expr1^) `...^
      ([`condition^] `exprn^)`...^
      `else...^\(else \`cursor\^\)^^)


XPT let hint=(let\ [(var\ (val))\ ..]\ (body))
(let [(`newVar^ `value^ `...^)
      (`newVarn^ `valuen^`...^)]
     (`cursor^))


XPT letrec hint=(letrec\ [(var\ (val))\ ..]\ (body))
(letrec [(`newVar^ `value^ `...^)
         (`newVarn^ `valuen^`...^)]
     (`cursor^))


XPT lambda hint=(lambda\ [params]\ (body))
(lambda [`params^]
        (`cursor^))


XPT defun hint=(define\ var\ (lambda\ ..))
(define `funName^
    (lambda [`params^]
        (`cursor^))
 )


XPT def hint=(define\ var\ (ex))
(define `varName^ `cursor^)


XPT do hint=(do\ ..)
(do {(`var1^ `init1^ `step1^) `...0^
     (`varn^ `initn^ `stepn^)`...0^}
   ([`test^] `exprs^ `...1^ `exprs^`...1^^)
   (`command0^) `...2^^
   (`command1^)`...2^)


