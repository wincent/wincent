if exists("b:__RUBY_XPT_VIM__")
  finish
endif
let b:__RUBY_XPT_VIM__ = 1



" containers
let [s:f, s:v] = XPTcontainer()

" inclusion
XPTinclude
      \ _common/common

" ========================= Function and Variables =============================

fun! s:f.RubyCamelCase(...) "{{{
  let str = a:0 == 0 ? self.V() : a:1
  let r = substitute(substitute(str, "[\/ _]", ' ', 'g'), '\<.', '\u&', 'g')
  return substitute(r, " ", '', 'g')
endfunction "}}}

fun! s:f.RubySnakeCase(...) "{{{
  let str = a:0 == 0 ? self.V() : a:1
  return substitute(str," ",'_','g')
endfunction "}}}

" Multiple each snippet {{{
let s:each_list = [
      \'each_byte',
      \'each_char',
      \'each_cons',
      \'each_index',
      \'each_key',
      \'each_line',
      \'each_pair',
      \'each_slice',
      \'each_value'
      \]

fun! s:f.RubyEachPopup() "{{{
  return s:each_list
endfunction "}}}

fun! s:f.RubyEachBrace() "{{{
  let v = self.V()

  if v =~# 'each_slice\|each_cons'
    return v.'(`val^3^)'
  else
    return v
  endif
endfunction "}}}

fun! s:f.RubyEachPair() "{{{
  let v = self.R('each_what')
  if v =~# 'each_pair'
    return '`el1^, `el2^'
  else
    let r = substitute(v[5:-1], "(.\\{-})", '', '')
    return '`' . r . '^'
  endif
endfunction "}}}
" End multiple each snippet }}}

" Multiple assert snippet {{{
let s:assert_map = {
      \'equals'         : '(`expected^, `actual^)'                      . '',
      \'in_delta'       : '(`expected float^, `actual float^, `delta^)' . '',
      \'instance_of'    : '(`class^, `object to compare^)'              . '',
      \'kind_of'        : '(`class^, `object to compare^)'              . '',
      \'match'          : '(/`regexp^/`^, `string^)'                    . '',
      \'not_equal'      : '(`expected^, `actual^)'                      . '',
      \'nil'            : '(`object^)'                                  . '',
      \'no_match'       : '(/`regexp^/`^, `string^)'                    . '',
      \'not_nil'        : '(`object^)'                                  . '',
      \'nothing_raised' : '(`exception^)'                               . '',
      \'not_same'       : '(`expected^, `actual^)'                      . '',
      \'operator'       : '(`obj1^, `operator^, `obj2^)'                . '',
      \'raise'          : '(`exception^, `message^)'                    . ' { `cursor^ } ',
      \'respond_to'     : '(`object^, `respond to this message^)'       . '',
      \'same'           : '(`expected^, `actual^)'                      . '',
      \'send'           : '(`send array^)'                              . '',
      \'throws'         : '(`expected symbol^)'                         . ' { `cursor^ } ',
      \}


fun! RubyAssertPopupSort(a, b)
  return a:a.word > a:b.word
endfunction

fun! s:f.RubyAssertPopup() "{{{
  let list = []
  for [k, v] in items(s:assert_map)
    let list += [{ 'word' : k, 'menu' : 'assert_' . k . substitute(v, '`.\{-}^', '..', 'g') }]
  endfor
  return sort(list, 'RubyAssertPopupSort')
endfunction "}}}

fun! RubyAssertMethod() "{{{
  let v = self.V()
  if has_key(s:assert_map, v)
    return v . s:assert_map[v]
  else
    return ''
  endif
endfunction "}}}
" End multiple assert snippet }}}

fun! s:f.RubyBlockArgs() "{{{
  let v = self.V()
  if v == ''
    return ''
  else
    return ' |' . self.S(self.S(v,"^ ", ''), "|", "", 'g') . "`, `arg..^ExpandIfNotEmpty(', ', 'arg..')^^" . '|'
  endif 
endfunction "}}}

fun! s:f.RubyMethodArgs() "{{{
  let v = self.V()
  if v == ''
    return ''
  else
    return '(' . self.S(v, "\[(\|)\]","") . "`, `arg..^ExpandIfNotEmpty(', ', 'arg..')^^" . ')'
  endif 
endfunction "}}}

" ================================= Snippets ===================================
XPTemplateDef
XPT BEG hint=BEGIN\ {\ ..\ }
BEGIN {
`cursor^
}


XPT Comp hint=include\ Comparable\ def\ <=>\ ...
include Comparable

def <=>(other)
`cursor^
end


XPT END hint=END\ {\ ..\ }
END {
`cursor^
}


XPT Enum hint=include\ Enumerable\ def\ each\ ...
include Enumerable

def each(&block)
`cursor^
end


XPT Forw hint=extend\ Forwardable
extend Forwardable


XPT Md hint=Marshall\ Dump
XSET file=file
File.open("`filename^", "wb") { |`file^| Marshal.dump(`obj^, `file^) }


XPT Ml hint=Marshall\ Load
XSET file=file
File.open("`filename^", "rb") { |`file^| Marshal.load(`file^) }


XPT Pn hint=PStore.new\\(..)
PStore.new("`filename^")


XPT Yd hint=YAML\ dump
XSET file=file
File.open("`filename^.yaml", "wb") { |`file^| YAML.dump(`obj^,`file^) }


XPT Yl hint=YAML\ load
XSET file=file
File.open("`filename^.yaml") { |`file^| YAML.load(`file^) }


XPT _d hint=__DATA__
__DATA__


XPT _e hint=__END__
__END__


XPT _f hint=__FILE__
__FILE__


XPT ali hint=alias\ :\ ..\ :\ ..
XSET new.post=RubySnakeCase()
XSET old=old_{R("new")}
XSET old.post=RubySnakeCase()
alias :`new^ :`old^


XPT all hint=all?\ {\ ..\ }
all? { |`element^| `cursor^ }


XPT amm hint=alias_method\ :\ ..\ :\ ..
XSET new.post=RubySnakeCase()
XSET old=old_{R("new")}
XSET old.post=RubySnakeCase()
alias_method :`new^, :`old^


XPT any hint=any?\ {\ |..|\ ..\ }
any? { |`element^| `cursor^ }


XPT app hint=if\ __FILE__\ ==\ $PROGRAM_NAME\ ...
if __FILE__ == $PROGRAM_NAME
`cursor^
end


XPT array hint=Array.new\\(..)\ {\ ...\ }
XSET arg=i
XSET size=5
Array.new(`size^) { |`arg^| `cursor^ }

XPT ass hint=assert\\(..)
XSET message...|post=, `_^
assert(`boolean condition^`, `message...^)


XPT ass_ hint=assert_**\\(..)\ ...
XSET what=RubyAssertPopup()
XSET what|post=RubyAssertMethod()
assert_`what^


XPT attr hint=attr_**\ :...
XSET what=Choose(["_accessor", "_reader", "_writer"])
XSET attr..|post=ExpandIfNotEmpty(', :', 'attr..')
attr`what^ :`attr..^

XPT begin hint=begin\ ..\ rescue\ ..\ else\ ..\ end
XSET exception=Exception
XSET block=# block
XSET rescue...|post=\nrescue `exception^` => `e^\n  `block^`\n`rescue...^
XSET else...|post=\nelse\n  `block^
XSET ensure...|post=\nensure\n  `cursor^
begin
  `expr^`
`rescue...^`
`else...^`
`ensure...^
end

XPT bm hint=Benchmark.bmbm\ do\ ...\ end
XSET times=10_000
TESTS = `times^

Benchmark.bmbm do |result|
`cursor^
end


XPT case hint=case\ ..\ when\ ..\ end
XSET when...|post=\nwhen `comparison^\n  `_^`\n`when...^
XSET else...|post=\nelse\n  `_^
XSET _=
case `target^`
`when...^`
`else...^
end


XPT cfy hint=classify\ {\ |..|\ ..\ }
classify { |`element^| `cursor^ }


XPT cl hint=class\ ..\ end
XSET ClassName.post=RubyCamelCase()
class `ClassName^
`cursor^
end


XPT cld hint=class\ ..\ <\ DelegateClass\ ..\ end
XSET ClassName.post=RubyCamelCase()
XSET ParentClass.post=RubyCamelCase()
XSET args|post=RubyMethodArgs()
class `ClassName^ < DelegateClass(`ParentClass^)
  def initialize`(`args`)^
    super(`delegate object^)

    `cursor^
  end
end


XPT cli hint=class\ ..\ def\ initialize\\(..)\ ...
XSET ClassName.post=RubyCamelCase()
XSET args|post=RubyMethodArgs()
XSET block=# block
XSET def...|post=\n\n  def `name^`(`args`)^\n    `block^\n  end`\n\n  `def...^
XSET name|post=RubySnakeCase()
class `ClassName^
  def initialize`(`args`)^
    `block^
  end`

  `def...^
end


XPT cls hint=class\ <<\ ..\ end
XSET self=self
class << `self^
`cursor^
end


XPT clstr hint=..\ =\ Struct.new\ ...
XSET do...|post= do\n`cursor^\nend
XSET ClassName|post=RubyCamelCase()
XSET attr..|post=ExpandIfNotEmpty(', :', 'attr..')
`ClassName^ = Struct.new(:`attr..^)` `do...^


XPT col hint=collect\ {\ ..\ }
collect { |`obj^| `cursor^ }


XPT deec hint=Deep\ copy
Marshal.load(Marshal.dump(`obj^))


XPT def hint=def\ ..\ end
XSET method|post=RubySnakeCase()
XSET args|post=RubyMethodArgs()
def `method^`(`args`)^
`cursor^
end


XPT defd hint=def_delegator\ :\ ...
def_delegator :`del obj^, :`del meth^, :`new name^


XPT defds hint=def_delegators\ :\ ...
def_delegators :`del obj^, :`del methods^


XPT defi hint=def\ initialize\ ..\ end
XSET args|post=RubyMethodArgs()
def initialize`(`args`)^
`cursor^
end


XPT defmm hint=def\ method_missing\\(..)\ ..\ end
def method_missing(meth, *args, &block)
`cursor^
end


XPT defs hint=def\ self...\ end
XSET method.post=RubySnakeCase()
XSET args|post=RubyMethodArgs()
def self.`method^`(`args`)^
`cursor^
end


XPT deft hint=def\ test_..\ ..\ end
XSET name|post=RubySnakeCase()
XSET args|post=RubyMethodArgs()
def test_`name^`(`args`)^
`cursor^
end


XPT deli hint=delete_if\ {\ |..|\ ..\ }
delete_if { |`arg^| `cursor^ }


XPT det hint=detect\ {\ ..\ }
detect { |`obj^| `cursor^ }


XPT dir hint=Dir[..]
XSET _='/**/*'
Dir[`_^]


XPT dirg hint=Dir.glob\\(..)\ {\ |..|\ ..\ }
XSET d=file
Dir.glob('`dir^') { |`f^| `cursor^ }


XPT do hint=do\ |..|\ ..\ end
XSET args|post=RubyBlockArgs()
do` |`args`|^
`^
end


XPT dow hint=downto\\(..)\ {\ ..\ }
XSET arg=i
XSET lbound=0
downto(`lbound^) { |`arg^| `cursor^ }


XPT ea hint=each\ {\ ..\ }
each { |`e^| `cursor^ }


XPT each hint=each_**\ {\ ..\ }
XSET each_what=RubyEachPopup()
XSET each_what|post=RubyEachBrace()
XSET vars=RubyEachPair()
`each_what^ { |`vars^| `cursor^ }


XPT fdir hint=File.dirname\\(..)
XSET _=
File.dirname(`_^)


XPT fet hint=fetch\\(..)\ {\ |..|\ ..\ }
fetch(`name^) { |`key^| `cursor^ }


XPT file hint=File.foreach\\(..)\ ...
XSET line=line
File.foreach('`filename^') { |`line^| `cursor^ }


XPT fin hint=find\ {\ |..|\ ..\ }
find { |`element^| `cursor^ }


XPT fina hint=find_all\ {\ |..|\ ..\ }
find_all { |`element^| `cursor^ }


XPT fjoin hint=File.join\\(..)
File.join(`dir^, `path^)


XPT fread hint=File.read\\(..)
File.read('`filename^')


XPT grep hint=grep\\(..)\ {\ |..|\ ..\ }
XSET match=m
grep(/`pattern^/) { |`match^| `cursor^ }


XPT gsub hint=gsub\\(..)\ {\ |..|\ ..\ }
XSET match=m
gsub(/`pattern^/) { |`match^| `cursor^ }


XPT hash hint=Hash.new\ {\ ...\ }
XSET hash=h
XSET key=k
Hash.new { |`hash^,`key^| `hash^[`key^] = `cursor^ }

XPT if hint=if\ ..\ elsif\ ..\ else\ ..\ end
XSET block=# block
XSET else...|post=\nelse\n`cursor^
XSET elsif...|post=\nelsif `boolean exp^\n  `block^`\n`elsif...^
if `boolean exp^
  `block^`
`elsif...^`
`else...^
end


XPT inj hint=inject\\(..)\ {\ |..|\ ..\ }
XSET accumulator=acc
XSET element=el
inject`(`arg`)^ { |`accumulator^, `element^| `cursor^ }


XPT int hint=#{..}
XSET _=
#{`_^}


XPT kv hint=:...\ =>\ ...
XSET _=\ 
:`key^ => `value^`...^,`_^:`keyn^ => `valuen^`...^


XPT lam hint=lambda\ {\ ..\ }
XSET args|post=RubyBlockArgs()
lambda {` |`args`|^ `cursor^ }


XPT lit hint=%**[..]
XSET _=Q
XSET content=
%`_^[`content^]

XPT loop hint=loop\ do\ ...\ end
loop do
`cursor^
end

XPT map hint=map\ {\ |..|\ ..\ }
map { |`arg^| `cursor^ }


XPT max hint=max\ {\ |..|\ ..\ }
max { |`element1^, `element2^| `cursor^ }


XPT min hint=min\ {\ |..|\ ..\ }
min { |`element1^, `element2^| `cursor^ }


XPT mod hint=module\ ..\ ..\ end
XSET module name|post=RubyCamelCase()
module `module name^
`cursor^
end


XPT modf hint=module\ ..\ module_function\ ..\ end
XSET module name|post=RubyCamelCase()
module `module name^
  module_function

  `cursor^
end


XPT nam hint=Rake\ Namespace
XSET ns=fileRoot()
namespace :`ns^ do
`cursor^
end


XPT new hint=Instanciate\ new\ object
XSET Object|post=RubyCamelCase()
XSET args|post=RubyMethodArgs()
`var^ = `Object^.new`(`args`)^


XPT open hint=open\\(..)\ {\ |..|\ ..\ }
XSET mode...|post=, '`wb^'
XSET wb=wb
XSET io=io
open("`filename^"`, `mode...^) { |`io^| `cursor^ }


XPT par hint=partition\ {\ |..|\ ..\ }
partition { |`element^| `cursor^ }


XPT pathf hint=Path\ from\ here
XSET path=../lib
File.join(File.dirname(__FILE__), "`path^")


XPT rb hint=#!/usr/bin/env\ ruby\ -w
#!/usr/bin/env ruby -w


XPT rdoc syn=comment hint=RDoc\ description
=begin rdoc
#`cursor^
#=end


XPT rej hint=reject\ {\ |..|\ ..\ }
reject { |`element^| `cursor^ }


XPT rep hint=Benchmark\ report
result.report("`name^: ") { TESTS.times { `cursor^ } }


XPT req hint=require\ ..
require '`lib^'


XPT reqs hint=%w[..].map\ {\ |lib|\ require\ lib\ }
XSET lib..|post=ExpandIfNotEmpty(' ', 'lib..')
%w[`lib..^].map { |lib| require lib }


XPT reve hint=reverse_each\ {\ ..\ }
reverse_each { |`element^| `cursor^ }


XPT scan hint=scan\\(..)\ {\ |..|\ ..\ }
XSET match=m
scan(/`pattern^/) { |`match^| `cursor^ }


XPT sel hint=select\ {\ |..|\ ..\ }
select { |`element^| `cursor^ }


XPT sinc hint=class\ <<\ self;\ self;\ end
class << self; self; end


XPT sor hint=sort\ {\ |..|\ ..\ }
sort { |`element1^, `element2^| `element1^ <=> `element2^ }


XPT sorb hint=sort_by\ {\ |..|\ ..\ }
sort_by {` |`arg`|^ `cursor^ }


XPT ste hint=step\\(..)\ {\ ..\ }
XSET arg=i
XSET count=10
step(`count^`, `step^) { |`arg^| `cursor^ }


XPT sub hint=sub\\(..)\ {\ |..|\ ..\ }
XSET match=m
sub(/`pattern^/) { |`match^| `cursor^ }


XPT subcl hint=class\ ..\ <\ ..\ end
XSET ClassName.post=RubyCamelCase()
XSET Parent.post=RubyCamelCase()
class `ClassName^ < `Parent^
`cursor^
end


XPT tas hint=Rake\ Task
XSET task name|post=RubySnakeCase()
XSET taskn...|post=, :`task^`, `taskn...^
XSET deps...|post= => [:`task^`, `taskn...^]
desc "`task description^"
task :`task name^` => [`deps...`]^ do
`cursor^
end


XPT tc hint=require\ 'test/unit'\ ...\ class\ Test..\ <\ Test::Unit:TestCase\ ...
XSET block=# block
XSET name|post=RubySnakeCase()
XSET ClassName=RubyCamelCase(R("module"))
XSET ClassName.post=RubyCamelCase()
XSET args|post=RubyMethodArgs()
XSET def...|post=\n\n  def test_`name^`(`args`)^\n    `block^\n  end`\n\n  `def...^
require "test/unit"
require "`module^"

class Test`ClassName^ < Test::Unit:TestCase
  def test_`name^`(`args`)^
    `block^
  end`

  `def...^
end


XPT tif hint=..\ ?\ ..\ :\ ..
(`boolean exp^) ? `exp if true^ : `exp if false^


XPT tim hint=times\ {\ ..\ }
times {` |`index`|^ `cursor^ }


XPT tra hint=transaction\\(..)\ {\ ...\ }
XSET _=true
transaction(`_^) { `cursor^ }


XPT unif hint=Unix\ Filter
XSET line=line
ARGF.each_line do |`line^|
`cursor^
end


XPT unless hint=unless\ ..\ end
unless `boolean cond^
`cursor^
end


XPT until hint=until\ ..\ end
until `boolean cond^
`cursor^
end


XPT upt hint=upto\\(..)\ {\ ..\ }
XSET arg=i
XSET ubound=10
upto(`ubound^) { |`arg^| `cursor^ }


XPT usai hint=if\ ARGV..\ abort("Usage...
XSET _=
XSET args=[options]
if ARGV`_^
  abort "Usage: #{$PROGRAM_NAME} `args^"
end


XPT usau hint=unless\ ARGV..\ abort("Usage...
XSET _=
XSET args=[options]
unless ARGV`_^
  abort "Usage: #{$PROGRAM_NAME} `args^"
end


XPT while hint=while\ ..\ end
while `boolean cond^
`cursor^
end


XPT wid hint=with_index\ {\ ..\ }
XSET index=i
with_index { |`element^, `index^| `cursor^ }


XPT xml hint=REXML::Document.new\\(..)
REXML::Document.new(File.read("`filename^"))


XPT y syn=comment hint=:yields:
:yields:


XPT zip hint=zip\\(..)\ {\ |..|\ ..\ }
XSET row=row
zip(`enum^) { |`row^| `cursor^ }
