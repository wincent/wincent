if has('conceal')
  setlocal concealcursor=nc

  " Fragile hack to stop indentLine plug-in from overwriting this back to "inc".
  let b:indentLine_ConcealOptionSet = 1
endif
