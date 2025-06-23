vim9script

def OpenFixativeBuffer()
    silent edit [Fixative Buffer]
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=
    setlocal filetype=fixative
enddef

defcompile

command Fixative :call OpenFixativeBuffer()
