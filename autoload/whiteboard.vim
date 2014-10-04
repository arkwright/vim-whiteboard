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
  try
    call whiteboard#GotoInputBuffer()
    call whiteboard#DeleteInputBufferMappings()
    call whiteboard#GotoSourceBuffer()
    only
  catch
    echoe 'Cannot close Whiteboard. Please close windows manually.'
  endtry

  unlet t:whiteboardInterpreter
  unlet t:whiteboardSourceBufferNumber
  unlet t:whiteboardInputBufferNumber
  unlet t:whiteboardOutputBufferNumber
endfunction

"""
" Creates and arranges the necessary buffers.
"
" @param    number    a:currentIsInput    1 if the current buffer should be used as
"                                         the Input Buffer, 0 otherwise.
"""
function! whiteboard#CreateBuffers(currentIsInput)
  let t:whiteboardSourceBufferNumber = bufnr('%')

  if a:currentIsInput ==# 0
    execute 'botright ' . g:whiteboard_buffer_width . 'vnew'
  endif

  let t:whiteboardInputBufferNumber = bufnr('%')

  if expand('%') ==# ''
    execute 'write! ' . g:whiteboard_temp_directory . 'whiteboard-' . t:whiteboardInputBufferNumber . '.' . t:whiteboardInterpreter.extension
  endif

  call whiteboard#CreateInputBufferMappings()

  if a:currentIsInput ==# 0
    rightbelow new
  else
    rightbelow vnew
  endif

  let t:whiteboardOutputBufferNumber = bufnr('%')

  setlocal buftype=nofile
  setlocal bufhidden=delete
  setlocal noswapfile

  silent! execute 'file [Whiteboard Output ' . t:whiteboardInputBufferNumber . ']'

  call whiteboard#GotoInputBuffer()
endfunction

"""
" Creates convenience mappings within the input buffer.
"""
function! whiteboard#CreateInputBufferMappings()
  nnoremap <buffer> <CR> :silent call whiteboard#DoRepl()<CR>
endfunction

"""
" Deletes convenience mappings within the input buffer.
"""
function! whiteboard#DeleteInputBufferMappings()
  nunmap <buffer> <CR>
endfunction

"""
" Executes one iteration of the REPL.
"""
function! whiteboard#DoRepl()
  update!

  let l:inputFilePath = expand('%')

  call whiteboard#GotoOutputBuffer()

  %delete
  
  execute '0read !' . t:whiteboardInterpreter.command . ' ' . l:inputFilePath

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
  call whiteboard#GotoWindowForBuffer(t:whiteboardInputBufferNumber)
endfunction

"""
" Moves the cursor to the output buffer.
"""
function! whiteboard#GotoOutputBuffer()
  call whiteboard#GotoWindowForBuffer(t:whiteboardOutputBufferNumber)
endfunction

"""
" Moves the cursor to the source buffer.
"""
function! whiteboard#GotoSourceBuffer()
  call whiteboard#GotoWindowForBuffer(t:whiteboardSourceBufferNumber)
endfunction

"""
" Moves the cursor to the input buffer.
"
" @param    number    a:buffer    The buffer number whose window should be
"                                 located within the current tab pane,
"                                 and focused within.
"""
function! whiteboard#GotoWindowForBuffer(buffer)
  execute bufwinnr(a:buffer) . 'wincmd w'
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

  let l:bang = a:1 ==# '!' ? 1 : 0
  let l:extension = expand('%:e')

  let l:type = g:whiteboard_default_interpreter

  if l:bang ==# 1   &&   l:extension !=# ''
    let l:type = l:extension
  endif

  if a:0 >=# 2
    if l:bang ==# 0   ||   l:extension ==# ''
      let l:type = a:2
    endif
  endif

  let l:interpreter = whiteboard#FindInterpreter(l:type)

  if type(l:interpreter) ==# type({})
    let t:whiteboardInterpreter = l:interpreter
  else
    echoe 'Whiteboard could not find interpreter for "' . l:type . '".'
    return
  endif

  call whiteboard#CreateBuffers(l:bang)
endfunction
