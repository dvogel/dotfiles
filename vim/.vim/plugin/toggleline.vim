function! CurrentLineIs (text)
  let current_text = getline(".")
  let save_cursor = getpos(".")
  let result = 0
  normal g0
  let cursor_line = line(".")
  if search("^[ ]*" . a:text . "[ ]*$", "cn", cursor_line) == cursor_line
    let result = 1
  end
  call setpos(".", save_cursor)
  return result
endfunction

function! ToggleLine (text)
  let cursor_line = line(".")
  if CurrentLineIs(a:text)
    normal dd
  else
    let @t = a:text . "\n"
    normal "tP
  endif
  call cursor(cursor_line)
endfunction

