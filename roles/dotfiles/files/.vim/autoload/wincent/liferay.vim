" TODO: make it possible to set up directory-specific overrides which
" take precedence over the auto-detection mechanism.
let s:directories={}

" Returns 1 if `file` looks like it belongs to a Liferay project.
function! wincent#liferay#detect(file) abort
  let l:git=wincent#git#get_git_dir(a:file)
  if l:git == ''
    let l:key=a:file
    let s:directories[l:key]=0
  else
    let l:key=l:git
    if !has_key(s:directories, l:key)
      let l:liferay=0
      try
        let l:remotes=system('git --git-dir=' . shellescape(l:git) . ' remote -v')
        let l:match=match(l:remotes, '\<liferay\>')
        let l:liferay=(l:match != -1)
      catch
        "
      endtry
      let s:directories[l:key]=l:liferay
    endif
  endif
  return s:directories[l:key]
endfunction
