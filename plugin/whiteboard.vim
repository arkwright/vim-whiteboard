"""
" User config via:
"
" let g:whiteboard_default_interpreter = 'javascript'
" let g:whiteboard_buffer_width = 80
" let g:whiteboard_temp_directory = '~/tmp/'
" let g:whiteboard_command_name = 'Whiteboard'
"
" let g:whiteboard_interpreters = {}
" let g:whiteboard_interpreters.javascript = { 'extension': 'js', 'command': 'node' }
"""

if exists('g:whiteboard_default_interpreter') ==# 0   ||   g:whiteboard_default_interpreter ==# ''
  let g:whiteboard_default_interpreter = 'javascript'
endif

if exists('g:whiteboard_buffer_width') ==# 0
  let g:whiteboard_buffer_width = 80
endif

if exists('g:whiteboard_temp_directory') ==# 0   ||   g:whiteboard_temp_directory ==# ''
  let s:dir = '~/tmp/'

  if $TMP !=# ''
    let s:dir = $TMP
  elseif $TEMP !=# ''
    let s:dir = $TEMP
  elseif $TMPDIR !=# ''
    let s:dir = $TMPDIR
  endif

  " Windows $TMP and $TEMP returns a directory path without a trailing
  " slash. So we have to check for and add one.
  if match(strpart(s:dir, strlen(s:dir) - 1, 1), '\v[\/\\]') ==# -1
    s:dir .= '/'
  endif

  let g:whiteboard_temp_directory = s:dir
endif

if exists('g:whiteboard_command_name') ==# 0   ||   g:whiteboard_command_name ==# ''
  let g:whiteboard_command_name = 'Whiteboard'
endif

if exists(':' . g:whiteboard_command_name) ==# 0
  execute 'command! -bang -nargs=* ' . g:whiteboard_command_name . ' call whiteboard#Whiteboard("<bang>", <f-args>)'
endif
