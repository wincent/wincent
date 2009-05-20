if exists( "b:__HASKELL_XPT_VIM__")
    finish
endif
let b:__HASKELL_XPT_VIM__ = 1

" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Varaibles =============================

" ================================= Snippets ===================================
call XPTemplateMark( '`', '~' )

XPTemplateDef
XPT class hint=class\ ..\ where..
class `context~~ `className~ `types~ where
    `ar~ :: `type~ `...~
    `methodName~ :: `methodType~`...~
`cursor~

XPT classcom hint=--\ |\ class..
-- | `classDescr~
class `context~~ `className~ `types~ where
    -- | `methodDescr~
    `ar~ :: `type~ `...~
    -- | `method_Descr~
    `methodName~ :: `methodType~`...~
`cursor~

XPT datasum hint=data\ ..\ =\ ..|..|..
data `context~~ `typename~ `typeParams~~ =
    `Constructor~ `ctorParams~~ `...~
  | `Ctor~ `params~~`...~
  `deriving...~deriving (\`Eq,Show\~)~~
`cursor~


XPT datasumcom hint=--\ |\ data\ ..\ =\ ..|..|..
-- | `typeDescr~~~
data `context~~ `typename~ `typeParams~~ =
    -- | `ConstructorDescr~~
    `Constructor~ `ctorParams~~ `...~
    -- | `Ctor descr~~
  | `Ctor~ `params~~`...~
  `deriving...~deriving (\`Eq,Show\~)~~
`cursor~

XPT parser hint=..\ =\ ..\ <|>\ ..\ <|>\ ..\ <?>
`funName~ = `rule~`...~
         <|> `rule~`...~
         `err...~<?> "\`descr\~"~~
`cursor~

XPT datarecord hint=data\ ..\ ={}
data `context~~ `typename~ `typeParams~~ =
     `Constructor~ {
       `field~ :: `type~ `...~
     , `fieldn~ :: `typen~`...~
     }
     `deriving...~deriving (\`Eq, Show\~)~~
`cursor~

XPT datarecordcom hint=--\ |\ data\ ..\ ={}
-- | `typeDescr~
data `context~~ `typename~ `typeParams~~ =
     `Constructor~ {
       `field~ :: `type~ -- ^ `fieldDescr~ `...~
     , `fieldn~ :: `typen~ -- ^ `fielddescr~`...~
     }
     `deriving...~deriving (\`Eq,Show\~)~~
`cursor~

XPT instance hint=instance\ ..\ ..\ where
instance `className~ `instanceTypes~ where
    `methodName~ `~ = `decl~ `...~
    `method~ `~ = `declaration~`...~
`cursor~

XPT if hint=if\ ..\ then\ ..\ else
if `expr~
    then `thenCode~
    else `cursor~

XPT module hint=module\ ..\ ()\ where ...
XSET moduleName=substitute(E('%:r'),'^.','\u&', '')
module `moduleName~ () where
`cursor~

XPT fun hint=fun\ pat\ =\ ..
`funName~ `pattern~ = `def~`...~
`name~R("funName")~ `pattern~ = `def~`...~
`cursor~

XPT funcom hint=--\ |\ fun\ pat\ =\ ..
-- | `function_description~
`funName~ :: `type~
`name~R("funName")~ `pattern~ = `def~`...~
`name~R("funName")~ `pattern~ = `def~`...~
`cursor~

