"=================================================
" File: plugin/undotree.vim
" Description: Manage your undo history in a graph.
" Author: Ming Bai <mbbill@gmail.com>
" License: BSD

" Avoid installing twice.
if exists('g:loaded_undotree')
    finish
endif
let g:loaded_undotree = 0

" At least version 7.3 with 005 patch is needed for undo branches.
" Refer to https://github.com/mbbill/undotree/issues/4 for details.
" Thanks kien
if v:version < 703
    command! -nargs=0 -bar UndotreeToggle :echoerr "undotree.vim needs Vim version >= 7.3"
    finish
endif
if (v:version == 703 && !has("patch005"))
    command! -nargs=0 -bar UndotreeToggle :echoerr "undotree.vim needs vim7.3 with patch005 applied."
    finish
endif
let g:loaded_undotree = 1   " Signal plugin availability with a value of 1.

"=================================================
"Options:

" Window layout
" style 1
" +----------+------------------------+
" |          |                        |
" |          |                        |
" | undotree |                        |
" |          |                        |
" |          |                        |
" +----------+                        |
" |          |                        |
" |   diff   |                        |
" |          |                        |
" +----------+------------------------+
" Style 2
" +----------+------------------------+
" |          |                        |
" |          |                        |
" | undotree |                        |
" |          |                        |
" |          |                        |
" +----------+------------------------+
" |                                   |
" |   diff                            |
" |                                   |
" +-----------------------------------+
" Style 3
" +------------------------+----------+
" |                        |          |
" |                        |          |
" |                        | undotree |
" |                        |          |
" |                        |          |
" |                        +----------+
" |                        |          |
" |                        |   diff   |
" |                        |          |
" +------------------------+----------+
" Style 4
" +-----------------------++----------+
" |                        |          |
" |                        |          |
" |                        | undotree |
" |                        |          |
" |                        |          |
" +------------------------+----------+
" |                                   |
" |                            diff   |
" |                                   |
" +-----------------------------------+
if !exists('g:undotree_WindowLayout')
    let g:undotree_WindowLayout = 1
endif

" e.g. using 'd' instead of 'days' to save some space.
if !exists('g:undotree_ShortIndicators')
    let g:undotree_ShortIndicators = 0
endif

" undotree window width
if !exists('g:undotree_SplitWidth')
    if g:undotree_ShortIndicators == 1
        let g:undotree_SplitWidth = 24
    else
        let g:undotree_SplitWidth = 30
    endif
endif

" diff window height
if !exists('g:undotree_DiffpanelHeight')
    let g:undotree_DiffpanelHeight = 10
endif

" auto open diff window
if !exists('g:undotree_DiffAutoOpen')
    let g:undotree_DiffAutoOpen = 1
endif

" if set, let undotree window get focus after being opened, otherwise
" focus will stay in current window.
if !exists('g:undotree_SetFocusWhenToggle')
    let g:undotree_SetFocusWhenToggle = 0
endif

" tree node shape.
if !exists('g:undotree_TreeNodeShape')
    let g:undotree_TreeNodeShape = '*'
endif

" tree vertical shape.
if !exists('g:undotree_TreeVertShape')
    let g:undotree_TreeVertShape = '|'
endif

" tree split shape.
if !exists('g:undotree_TreeSplitShape')
    let g:undotree_TreeSplitShape = '/'
endif

" tree return shape.
if !exists('g:undotree_TreeReturnShape')
    let g:undotree_TreeReturnShape = '\'
endif

if !exists('g:undotree_DiffCommand')
    let g:undotree_DiffCommand = "diff"
endif

" relative timestamp
if !exists('g:undotree_RelativeTimestamp')
    let g:undotree_RelativeTimestamp = 1
endif

" Highlight changed text
if !exists('g:undotree_HighlightChangedText')
    let g:undotree_HighlightChangedText = 1
endif

" Highlight changed text using signs in the gutter
if !exists('g:undotree_HighlightChangedWithSign')
    let g:undotree_HighlightChangedWithSign = 1
endif

" Highlight linked syntax type.
" You may chose your favorite through ":hi" command
if !exists('g:undotree_HighlightSyntaxAdd')
    let g:undotree_HighlightSyntaxAdd = "DiffAdd"
endif
if !exists('g:undotree_HighlightSyntaxChange')
    let g:undotree_HighlightSyntaxChange = "DiffChange"
endif
if !exists('g:undotree_HighlightSyntaxDel')
    let g:undotree_HighlightSyntaxDel = "DiffDelete"
endif

" Signs to display in the gutter where the file has been modified
if !exists('g:undotree_SignAdded')
    let g:undotree_SignAdded = "++"
endif
if !exists('g:undotree_SignChanged')
    let g:undotree_SignChanged = "~~"
endif
if !exists('g:undotree_SignDeleted')
    let g:undotree_SignDeleted = "--"
endif
if !exists('g:undotree_SignDeletedEnd')
    let g:undotree_SignDeletedEnd = "-v"
endif

" Deprecates the old style configuration.
if exists('g:undotree_SplitLocation')
    echo "g:undotree_SplitLocation is deprecated,
                \ please use g:undotree_WindowLayout instead."
endif

" Show help line
if !exists('g:undotree_HelpLine')
    let g:undotree_HelpLine = 1
endif

" Show cursorline
if !exists('g:undotree_CursorLine')
    let g:undotree_CursorLine = 1
endif

" Set statusline
if !exists('g:undotree_StatusLine')
    let g:undotree_StatusLine = 1
endif

" Ignored filetypes
if !exists('g:undotree_DisabledFiletypes')
    let g:undotree_DisabledFiletypes = []
endif

" Ignored buftypes
if !exists('g:undotree_DisabledBuftypes')
    let g:undotree_DisabledBuftypes = ['terminal', 'prompt', 'quickfix', 'nofile']
endif

" Define the default persistence undo directory if not defined in vim/nvim
" startup script.
if !exists('g:undotree_UndoDir')
    let s:undoDir = &undodir
    let s:subdir = has('nvim') ? 'nvim' : 'vim'
    if s:undoDir == "."
        let s:undoDir = $HOME . '/.local/state/' . s:subdir . '/undo/'
    endif
    let g:undotree_UndoDir = s:undoDir
endif

augroup undotreeDetectPersistenceUndo
    au!
    au BufReadPost * call undotree#UndotreePersistUndo(0)
augroup END

"=================================================
" User commands.
command! -nargs=0 -bar UndotreeToggle      :call undotree#UndotreeToggle()
command! -nargs=0 -bar UndotreeHide        :call undotree#UndotreeHide()
command! -nargs=0 -bar UndotreeShow        :call undotree#UndotreeShow()
command! -nargs=0 -bar UndotreeFocus       :call undotree#UndotreeFocus()
command! -nargs=0 -bar UndotreePersistUndo :call undotree#UndotreePersistUndo(1)

" vim: set et fdm=marker sts=4 sw=4:
