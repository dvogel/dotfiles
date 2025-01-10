vim9script

def OpenFixativeBuffer()
    edit [Fixative Buffer]
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal filetype=fixative
enddef

defcompile

command Fixative :call OpenFixativeBuffer()
