if exists('g:loaded_syntastic_beancount_bean_check')
    finish
endif

let g:loaded_syntastic_beancount_bean_check=1

let s:save_cpo = &cpoptions
set cpoptions&vim

function! SyntaxCheckers_beancount_bean_check_IsAvailable() dict
    return executable(l:self.getExec())
endfunction

function! SyntaxCheckers_beancount_bean_check_GetLocList() dict
    let l:makeprg = l:self.makeprgBuild({})
    return SyntasticMake({ 'makeprg': l:makeprg })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'beancount',
    \ 'name': 'bean_check',
    \ 'exec': 'bean-check'})

let &cpoptions = s:save_cpo
unlet s:save_cpo
