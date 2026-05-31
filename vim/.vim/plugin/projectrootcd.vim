" Copied from vim-projectroot README

function! <SID>AutoProjectRootCD()
  try
    if &ft != 'help'
      ProjectRootCD
    endif
  catch
    " Silently ignore invalid buffers
  endtry
endfunction

augroup AutoProjectRootCD
  autocmd BufEnter * call <SID>AutoProjectRootCD()
  autocmd BufReadPost * call <SID>AutoProjectRootCD()
augroup END

