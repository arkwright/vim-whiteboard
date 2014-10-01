"""
" User config via:
"
" let g:whiteboard_command_name = 'Whiteboard'
"""

if exists('g:whiteboard_command_name') ==# 0   ||   g:whiteboard_command_name ==# ''
  let g:whiteboard_command_name = 'Whiteboard'
endif

" Dynamically create the Whiteboard invocation command, unless an identically
" named command already exists.
if exists(':' . g:whiteboard_command_name) ==# 0
  execute 'command! -nargs=* ' . g:whiteboard_command_name . ' call whiteboard#Whiteboard(<f-args>)'
endif
