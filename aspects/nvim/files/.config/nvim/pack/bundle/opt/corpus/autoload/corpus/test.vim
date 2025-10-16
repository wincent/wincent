" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the MIT license.

function! corpus#test#extract_link_reference_definition() abort
  call assert_equal(
        \   corpus#extract_link_reference_definition('[foo]: /wiki/foo'),
        \   ['foo', '/wiki/foo']
        \ )
  call assert_equal(
        \   corpus#extract_link_reference_definition('[foo: /wiki/foo'),
        \   []
        \ )
endfunction
