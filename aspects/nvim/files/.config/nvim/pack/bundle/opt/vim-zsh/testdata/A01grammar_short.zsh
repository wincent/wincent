  case horrible in
    ([a-m])(|[n-z])rr(|ib(um|le|ah)))
    print It worked
    ;;
  esac
  case "a string with separate words" in
    (*with separate*))
    print That worked, too
    ;;
  esac
 () {}
0:Unbalanced parentheses and spaces with zsh pattern
>It worked
>That worked, too

  case horrible in
    (([a-m])(|[n-z])rr(|ib(um|le|ah)))
    print It worked
    ;;
  esac
  case "a string with separate words" in
    (*with separate*)
    print That worked, too
    ;;
  esac
0:Balanced parentheses and spaces with zsh pattern
>It worked
>That worked, too

  fn() {
    typeset ac_file="the else branch"
    case $ac_file in
      *.$ac_ext | *.xcoff | *.tds | *.d | *.pdb | *.xSYM | *.bb | *.bbg | *.map | *.inf | *.dSYM | *.o | *.obj ) ;;
      *.* ) break;;
      *)
      ;;
    esac
    print Stuff here
  }
  which fn
  fn
0:Long case with parsed alternatives turned back into text
>fn () {
>	typeset ac_file="the else branch" 
>	case $ac_file in
>		(*.$ac_ext | *.xcoff | *.tds | *.d | *.pdb | *.xSYM | *.bb | *.bbg | *.map | *.inf | *.dSYM | *.o | *.obj)  ;;
>		(*.*) break ;;
>		(*)  ;;
>	esac
>	print Stuff here
>}
>Stuff here

  (exit 37)
  case $? in
    (37) echo $?
    ;;
  esac
0:case retains exit status for execution of cases
>37

  false
  case stuff in
    (nomatch) foo
    ;;
  esac
  echo $?
0:case sets exit status to zero if no patterns are matched
>0

  case match in
    (match) true; false; (exit 37)
    ;;
  esac
  echo $?
0:case keeps exit status of last command executed in compound-list
>37

  case '' in
    burble) print No.
    ;;
    spurble|) print Yes!
    ;;
    |burble) print Not quite.
    ;;
  esac
  case '' in
    burble) print No.
    ;;
    |burble) print Wow!
    ;;
    spurble|) print Sorry.
    ;;
  esac
  case '' in
    gurgle) print No.
    ;;
    wurgle||jurgle) print Yikes!
    ;;
    durgle|) print Hmm.
    ;;
    |zurgle) print Hah.
    ;;
  esac
  case '' in
    # Useless doubled empty string to check special case.
    ||jurgle) print Ok.
    ;;
  esac
0: case with no opening parentheses and empty string 
>Yes!
>Wow!
>Yikes!
>Ok.

  x=1
  x=2 | echo $x
  echo $x
0:Assignment-only current shell commands in LHS of pipelin
>1
>1

 echo pipe | ; sed s/pipe/PIPE/
 true && ; echo and true
 false && ; echo and false
 true || ; echo or true
 false || ; echo or false
0:semicolon is equivalent to newline
>PIPE
>and true
>or false

 $ZTST_testdir/../Src/zsh -fc '{ ( ) } always { echo foo }'
-f:exec last command optimization inhibited for try/always
>foo
