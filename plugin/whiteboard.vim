"""
" User config via:
"
" let g:whiteboard_default_interpreter = 'javascript'
" let g:whiteboard_buffer_width = 80
" let g:whiteboard_command_name = 'Whiteboard'
"
" let g:whiteboard_interpreters = {}
" let g:whiteboard_interpreters.javascript = { 'filetype': 'javascript', 'extension': 'js', 'command': 'node' }
"""

if exists('g:whiteboard_default_interpreter') ==# 0   ||   g:whiteboard_default_interpreter ==# ''
  let g:whiteboard_default_interpreter = 'javascript'
endif

if exists('g:whiteboard_buffer_width') ==# 0
  let g:whiteboard_buffer_width = 80
endif

if exists('g:whiteboard_command_name') ==# 0   ||   g:whiteboard_command_name ==# ''
  let g:whiteboard_command_name = 'Whiteboard'
endif

if exists(':' . g:whiteboard_command_name) ==# 0
  execute 'command! -nargs=* ' . g:whiteboard_command_name . ' call whiteboard#Whiteboard(<f-args>)'
endif
