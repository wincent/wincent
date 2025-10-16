" Copyright 2018-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

""
" @function ferret#get_default_arguments
"
" Call this with an executable name to find out the default arguments that will
" be passed when invoking that executable. For example:
"
" ```
" echo ferret#get_default_arguments('rg')
" ```
"
" This may be useful if you wish to extend or otherwise modify the arguments
" by setting |g:FerretExecutableArguments|.
"
function! ferret#get_default_arguments(executable) abort
  return get(ferret#private#executables(), a:executable, '')
endfunction
