if exists("b:__OCAML_XPT_VIM__")
    finish
endif

let b:__OCAML_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
XPTemplateDef

XPT letin hint=let\ ..\ =\ ..\ in
let `name^ `_^^ =
    `what^ `...^
and `subname^ `_^^ =
    `subwhat^`...^
in


XPT letrecin hint=let\ rec\ ..\ =\ ..\ in
let rec `name^ `_^^ =
    `what^ `...^
and `subname^ `_^^ =
    `subwhat^`...^
in


XPT if hint=if\ ..\ then\ ..\ else\ ..
if `cond^
    then `thenexpr^`else...^
    else \`cursor\^^^


XPT match hint=match\ ..\ with\ ..\ ->\ ..\ |
match `expr^ with
  | `what0^ -> `with0^ `...^
  | `what^ -> `with^`...^


XPT moduletype hint=module\ type\ ..\ =\ sig\ ..\ end
module type `name^ `^^ = sig
    `cursor^
end


XPT module hint=module\ ..\ =\ struct\ ..\ end
module `name^ `^^ = struct
    `cursor^
end


XPT class hint=class\ ..\ =\ object\ ..\ end
class `_^^ `name^ =
object (self)
    `cursor^
end


XPT classtype hint=class\ type\ ..\ =\ object\ ..\ end
class type `name^ =
object
   method `field0^ : `type0^ `...^
   method `field^ : `type^`...^
end

            

XPT classtypecom hint=(**\ ..\ *)\ class\ type\ ..\ =\ object\ ..\ end
(** `class_descr^^ *)
class type `name^ =
object
   (** `method_descr^^ *)
   method `field0^ : `type0^ `...^
   (** `method_descr2^^ *)
   method `field^ : `type^`...^
end


XPT typesum hint=type\ ..\ =\ ..\ |\ ..
type `_^^ `typename^ =
  | `constructor^ `...^
  | `constructor2^`...^

            
XPT typesumcom hint=(**\ ..\ *)\ type\ ..\ =\ ..\ |\ ..
(** `typeDescr^ *)
type `_^^ `typename^ =
  | `constructor^ (** `ctordescr^ *) `...^
  | `constructor2^ (** `ctordescr^ *)`...^


XPT typerecord hint=type\ ..\ =\ {\ ..\ }
type `_^^ `typename^ =
    { `recordField^ : `fType^ `...^
    ; `otherfield^ : `othertype^`...^
    }


XPT typerecordcom hint=(**\ ..\ *)type\ ..\ =\ {\ ..\ }
(** `type_descr^ *)
type `_^^ `typename^ =
    { `recordField^ : `fType^ (** `desc^ *) `...^
    ; `otherfield^ : `othertype^ (** `desc^ *)`...^
    }

            
XPT try hint=try\ ..\ with\ ..\ ->\ ..
try `expr^
with `exc^ -> `rez^`...^
   | `exc2^ -> `rez2^`...^


