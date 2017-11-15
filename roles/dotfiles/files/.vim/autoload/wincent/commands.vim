function! s:preview(file) abort
  " TODO: remove this hack once new version of Marked 2 is out:
  " http://support.markedapp.com/discussions/questions/8670
  silent! execute '!xattr -d com.apple.quarantine ' . shellescape(a:file)
  silent execute '!open -a "Marked 2.app" ' . shellescape(a:file)
endfunction

function! wincent#commands#preview(...) abort
  if a:0 == 0
    call s:preview(expand('%'))
  else
    for l:file in a:000
      call s:preview(l:file)
    endfor
  endif
endfunction

function! s:open_in_diffusion(file) abort
  let l:relative_path=''
  let l:repos=keys(g:diffusion_map)
  for l:repo in l:repos
    let l:base=g:diffusion_map[l:repo]
    let l:var='$' . l:repo
    if exists(l:var)
      let l:directory=resolve(eval(l:var))

      if stridx(a:file, l:directory) == 0
        let l:relative_path=strcharpart(a:file, strchars(l:directory))
        break
      endif
    endif
  endfor

  if l:relative_path ==# ''
    call wincent#functions#echoerr('Could not find repo configuration for file ' . a:file)
    return
  endif

  if has('macunix')
    " We don't just check for `executable('open')` to avoid false positives on
    " non-macOS systems.
    let l:url=shellescape(l:base . s:url_encode(l:relative_path))
    call system('open ' . l:url)
  else
    let l:url=l:base . l:relative_path
    call setreg('@', l:url)
    call clipper#private#clip()
    echomsg 'URL copied to clipboard.'
  endif
endfunction

" Opens the specified files (or the current file if there is no explicit
" selection) in Diffusion.
"
" Depends on `g:diffusion_map` being set up in `plugin/private.vim`.
function! wincent#commands#open_in_diffusion(...) abort
  if a:0 == 0
    let l:files=[expand('%')]
  else
    let l:files=a:000
  endif
  let l:did_open=0
  for l:file in l:files
    let l:file=fnamemodify(l:file, ':p')
    if l:file !=# ''
      call s:open_in_diffusion(l:file)
      let l:did_open=1
    endif
  endfor

  if !l:did_open
    call wincent#functions#echoerr('No filename')
    return
  endif
endfunction

" Try to open the module under the cursor in Diffusion.
"
" Depends on g:search_base being set up in `plugin/private.vim`.
function! s:search(query) abort
  " ibgs: normal search
  " ibgl: "lucky" search, if results unambiguous
  let l:url=shellescape(
        \   g:search_base . 'ibgl+' .
        \   s:url_encode(a:query)
        \ )
  call system('open ' . l:url)
endfunction

" Based on method of same name in: https://github.com/tpope/vim-unimpaired
function! s:url_encode(string) abort
  return substitute(
        \   a:string,
        \   '[^A-Za-z0-9_.~-]',
        \   '\="%" . printf("%02X", char2nr(submatch(0)))',
        \   'g'
        \ )
endfunction

function! wincent#commands#search(query) abort
  if a:query ==# ''
    call s:search(expand('<cword>'))
  else
    call s:search(a:query)
  endif
endfunction
