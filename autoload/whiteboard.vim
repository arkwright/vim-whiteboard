"""
" Closes Whiteboard and returns to the starting buffer.
"""
function! whiteboard#Close()
  if exists('b:whiteboardSourceBufferNumber') !=# 0
    execute 'buffer! ' . b:whiteboardSourceBufferNumber
    only
  else
    echoe 'Cannot close Whiteboard. Please close windows manually.'
  endif
endfunction

"""
" Creates the necessary buffers.
"
" @param    string    a:type    The REPL type to use, e.g., 'javascript'.
"""
function! whiteboard#CreateBuffers(type)
  let l:bufferWidth = 80

  let l:whiteboardSourceBufferNumber = bufnr('%')
  let b:whiteboardSourceBufferNumber = l:whiteboardSourceBufferNumber

  execute 'botright ' . l:bufferWidth . 'vnew'

  let l:inputBufferNumber = bufnr('%')
  let b:whiteboardSourceBufferNumber = l:whiteboardSourceBufferNumber

  execute 'file /tmp/whiteboard-' . l:inputBufferNumber . '.js'
  set filetype=javascript
  write!

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
  let l:inputFileType = &filetype

  call whiteboard#GotoOutputBuffer()

  %delete
  
  execute '0read !node ' . l:inputFilePath

  normal! Gdd

  call whiteboard#GotoInputBuffer()
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

" The main Whiteboard invocation function.
"
" If called with a string argument, invokes Manhunt using the specified REPL type.
" If called without an argument, toggles Whiteboard using the default REPL type.
"
" @param    string    a:type    The REPL type to use, e.g., 'javascript'.
"""
function! whiteboard#Whiteboard(...)
  " Toggle Whiteboard off if it is already on.
  if s:IsWhiteboardActive() ==# 1
    call whiteboard#Close()
    return
  endif

  let l:type = 'javascript'

  if a:0 >=# 1
    let l:type = a:1
  endif

  call whiteboard#CreateBuffers(l:type)
endfunction
