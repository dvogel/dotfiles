vim9script

def OpenFixativeBuffer()
    enew
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=
    silent file [Fixative Buffer]
    setlocal filetype=fixative
enddef

defcompile

command Fixative :call OpenFixativeBuffer()
