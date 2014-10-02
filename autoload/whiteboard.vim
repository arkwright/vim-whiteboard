"""
" Initialization
"""
if exists('g:whiteboard_interpreters') ==# 0
  let g:whiteboard_interpreters = {}
endif

if type(g:whiteboard_interpreters) ==# type({})
  let s:interpreters = {}

  let s:interpreters.javascript = { 'extension': 'js',  'command': 'node'   }
  let s:interpreters.php        = { 'extension': 'php', 'command': 'php'    }
  let s:interpreters.python     = { 'extension': 'py',  'command': 'python' }
  let s:interpreters.ruby       = { 'extension': 'rb',  'command': 'ruby'   }

  " Merge default interpreters into user's custom interpreters.
  " User's interpreters are preferred.
  for key in keys(s:interpreters)
    if has_key(g:whiteboard_interpreters, key) ==# 0
      let g:whiteboard_interpreters[key] = s:interpreters[key]
    endif
  endfor
endif

"""
" Closes Whiteboard and returns to the starting buffer.
"""
function! whiteboard#Close()
  unlet t:whiteboard_interpreter

  if exists('b:whiteboardSourceBufferNumber') !=# 0
    execute 'buffer! ' . b:whiteboardSourceBufferNumber
    only
  else
    echoe 'Cannot close Whiteboard. Please close windows manually.'
  endif
endfunction

"""
" Creates the necessary buffers.
"""
function! whiteboard#CreateBuffers()
  let l:whiteboardSourceBufferNumber = bufnr('%')
  let b:whiteboardSourceBufferNumber = l:whiteboardSourceBufferNumber

  execute 'botright ' . g:whiteboard_buffer_width . 'vnew'

  let l:inputBufferNumber = bufnr('%')
  let b:whiteboardSourceBufferNumber = l:whiteboardSourceBufferNumber

  execute 'write! /tmp/whiteboard-' . l:inputBufferNumber . '.' . t:whiteboard_interpreter.extension

  call whiteboard#CreateInputBufferMappings()

  new
  setlocal buftype=nofile
  setlocal bufhidden=delete
  setlocal noswapfile

  silent! execute 'file [Whiteboard Output ' . l:inputBufferNumber . ']'

  let b:whiteboardSourceBufferNumber = l:whiteboardSourceBufferNumber

  call whiteboard#GotoInputBuffer()
endfunction

"""
" Creates convenience mappings within the input buffer.
"""
function! whiteboard#CreateInputBufferMappings()
  nnoremap <buffer> <CR> :silent call whiteboard#DoRepl()<CR>
endfunction

"""
" Executes one iteration of the REPL.
"""
function! whiteboard#DoRepl()
  update!

  let l:inputFilePath = expand('%')

  call whiteboard#GotoOutputBuffer()

  %delete
  
  execute '0read !' . t:whiteboard_interpreter.command . ' ' . l:inputFilePath

  normal! Gdd

  call whiteboard#GotoInputBuffer()
endfunction

"""
" Finds an interpreter associated with the specified string.
"
" @param    string        a:type  The type of interpreter to find,
"                                 e.g. 'javascript'.
"
" @return   dictionary            The interpreter configuration data.
"""
function! whiteboard#FindInterpreter(type)
  " Prefer selecting interpreter by nickname.
  if exists('g:whiteboard_interpreters.' . a:type) ==# 1
    return g:whiteboard_interpreters[a:type]
  endif

  " Next preference is selecting interpreter by file extension.
  for nickname in keys(g:whiteboard_interpreters)
    if exists('g:whiteboard_interpreters.' . nickname . '.extension') ==# 1
      if g:whiteboard_interpreters[nickname].extension ==# a:type
        return g:whiteboard_interpreters[nickname]
      endif
    endif
  endfor

  " No interpreter was found!
  return 0
endfunction

"""
" Moves the cursor to the input buffer.
"""
function! whiteboard#GotoInputBuffer()
  execute '3wincmd w'
endfunction

"""
" Moves the cursor to the output buffer.
"""
function! whiteboard#GotoOutputBuffer()
  execute '2wincmd w'
endfunction

"""
" Returns a value indicating if Whiteboard is currently active.
"
" @return    number    Returns 1 if Whiteboard is active, 0 otherwise.
"""
function! s:IsWhiteboardActive()
  " tabpagenr() is the number of the current tab page
  " '$' returns the number of windows in the specified tab page
  let l:windowCount = tabpagewinnr(tabpagenr(), '$')

  if l:windowCount !=# 1
    return 1
  endif

  return 0
endfunction

"""
" The main Whiteboard invocation function.
"
" If called with a string argument, invokes Manhunt using the specified REPL
" type. If called without an argument, toggles Whiteboard using the default
" REPL type.
"
" @param    string    a:1    The REPL interpreter to use, e.g., 'javascript'.
"                            Can be either the interpreter's nickname, or
"                            the file extension associated with the
"                            interpreter.
"""
function! whiteboard#Whiteboard(...)
  " Toggle Whiteboard off if it is already on.
  if s:IsWhiteboardActive() ==# 1
    call whiteboard#Close()
    return
  endif

  let l:type = g:whiteboard_default_interpreter

  if a:0 >=# 1
    let l:type = a:1
  endif

  let l:interpreter = whiteboard#FindInterpreter(l:type)

  if type(l:interpreter) ==# type({})
    let t:whiteboard_interpreter = l:interpreter
  else
    echoe 'Whiteboard could not find interpreter for "' . l:type . '".'
    return
  endif

  call whiteboard#CreateBuffers()
endfunction
