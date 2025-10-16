" Vim syntax file
" Language: Kitty session

if exists("b:current_syntax")
  finish
endif

syn match kittyKW '^\S*' contains=kittySessionCommand,kittyInvalidKeyword
syn match kittyInvalidKeyword '\S*' contained
syn match kittyComment /^\s*#.*$/ contains=kittyTodo
syn region kittyString start=+"+ skip=+\\\\\|\\"+ end=+"+ oneline
syn region kittyString start=+'+ skip=+\\\\\|\\'+ end=+'+ oneline
syn keyword kittyTodo contained TODO FIXME XXX contained

syn keyword kittySessionCommand
	\ launch
	\ new_tab
	\ new_os_window
	\ layout
	\ focus
	\ focus_os_window
	\ enabled_layouts
	\ cd
	\ title
	\ os_window_size
	\ os_window_class
	\ os_window_state
	\ os_window_name
	\ resize_window
	\ focus_matching_window

hi def link kittySessionCommand Keyword
hi def link kittyComment Comment
hi def link kittyTodo	Todo
hi def link kittyInvalidKeyword Error
hi def link kittyString String
