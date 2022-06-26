vim9script

#============================================================================
#    Copyright: Copyright (c) 2022, Drew Vogel
# Name Of File: groupedbufexplorer.vim
#  Description: Buffer explorer plugin that is designed to support working on
#               multiple projects within the same vim session.
#
#    Forked from:
#    Copyright: Copyright (c) 2001-2018, Jeff Lanzarotta
#               All rights reserved.
#
#               Redistribution and use in source and binary forms, with or
#               without modification, are permitted provided that the
#               following conditions are met:
#
#               * Redistributions of source code must retain the above
#                 copyright notice, this list of conditions and the following
#                 disclaimer.
#
#               * Redistributions in binary form must reproduce the above
#                 copyright notice, this list of conditions and the following
#                 disclaimer in the documentation and/or other materials
#                 provided with the distribution.
#
#               * Neither the name of the {organization} nor the names of its
#                 contributors may be used to endorse or promote products
#                 derived from this software without specific prior written
#                 permission.
#
#               THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
#               CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
#               INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#               MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#               DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
#               CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#               SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
#               NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#               LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
#               HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
#               CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#               OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
#               EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# Name Of File: bufexplorer.vim
#  Description: Buffer Explorer Vim Plugin
#   Maintainer: Jeff Lanzarotta (delux256-vim at outlook dot com)
# Last Changed: Saturday, 08 December 2018
#      Version: See g:bufexplorer_version for version number.
#        Usage: This file should reside in the plugin directory and be
#               automatically sourced.
#
#               You may use the default keymappings of
#
#                 <Leader>be  - Opens BufExplorer
#                 <Leader>bt  - Toggles BufExplorer open or closed
#                 <Leader>bs  - Opens horizontally split window BufExplorer
#                 <Leader>bv  - Opens vertically split window BufExplorer
#
#               Or you can override the defaults and define your own mapping
#               in your vimrc file, for example:
#
#                   nnoremap <silent> <F11> :BufExplorer<CR>
#                   nnoremap <silent> <s-F11> :ToggleBufExplorer<CR>
#                   nnoremap <silent> <m-F11> :BufExplorerHorizontalSplit<CR>
#                   nnoremap <silent> <c-F11> :BufExplorerVerticalSplit<CR>
#
#               Or you can use
#
#                 ":BufExplorer"                - Opens BufExplorer
#                 ":ToggleBufExplorer"          - Opens/Closes BufExplorer
#                 ":BufExplorerHorizontalSplit" - Opens horizontally window BufExplorer
#                 ":BufExplorerVerticalSplit"   - Opens vertically split window BufExplorer
#
#               For more help see supplied documentation.
#      History: See supplied documentation.
#=============================================================================


# if exists("g:groupedbufexplorer_version") || &cp
#     finish
# endif

# g:groupedbufexplorer_version = "0.0.1"

# This is redundant since the vim9script declaration will only work on sufficiently high 802xxxx versions
if v:versionlong < 8025141
    finish
endif

command! GBufExplorer GBufExplorer()
command! GToggleBufExplorer GToggleBufExplorer()
command! GBufExplorerHorizontalSplit GBufExplorerHorizontalSplit()
command! GBufExplorerVerticalSplit GBufExplorerVerticalSplit()

def Set(var: string, default: any): bool
    if !exists(var)
        if type(default)
            execute "let" var "=" string(default)
        else
            execute "let" var "=" default
        endif

        return v:true
    endif

    return v:false
enddef

var noNamePlaceholder = "[No Name]"
var MRU_Exclude_List = ["[BufExplorer]", "__MRU_Files__", "[Buf\ List]"]
var allBuffers: list<dict<any>> = []
var fileGroups = {}
var mruGroups = {}
var mruBuffers = {}
var mruCounter = 0
var defaultGroupKey = 'Ungrouped Files'
var pluginBufName = '[GroupedBufExplorer]'
var originBufNr = 0
var firstBufferLine = 1
var running = v:false
var splitMode = ""
# Keeping these for reference but I plan to completely rewrite the display
# logic
# let s:types = {"fullname": ':p', "path": ':p:h', "relativename": ':~:.', "relativepath": ':~:.:h', "shortname": ':t'}

# Global settings that need to be temporarily overridden at times.
var _insertmode = &insertmode
var _showcmd = &showcmd
var _cpo = &cpo
var _report = &report

def DebugDump(): void
    echo keys(fileGroups)
    echo mruGroups
    echo mruBuffers
    echo mruCounter
    for bufObj in allBuffers
        echo bufObj
    endfor
enddef

command! GBEDebug DebugDump()

export def GBufExplorerSetup(): void
    allBuffers = CollectBufferInfo()
    Reset()

    # Now that the MRUList is created, add the other autocmds.
    augroup GroupedBufExplorer
        autocmd!
        autocmd BufEnter,BufNew * ActivateBuffer()
        autocmd BufWipeOut * DeactivateBuffer()
        autocmd BufDelete * DeactivateBuffer()
        autocmd BufWinEnter \[BufExplorer\] Initialize()
        autocmd BufWinLeave \[BufExplorer\] Cleanup()
    augroup END
enddef

def Reset()
    # Build initial MRU tables. This makes sure all the files specified on the
    # command line are picked up correctly.
	for bufObj in allBuffers
        mruBuffers[bufObj.bufnr] = NextMRUCounter()
        mruGroups[bufObj.groupkey] = NextMRUCounter()
    endfor
enddef

def ActivateBuffer(): void
    var bufnr = bufnr("%")
    MRUPush(bufnr)
enddef

def DeactivateBuffer(): void
    var bufnr = str2nr(expand("<abuf>"))
    MRUPop(bufnr)
enddef

def LookupBuf(bufnr: number): any
    for bufObj in allBuffers
        if bufObj.bufnr == bufnr
            return bufObj
        endif
    endfor
	return v:null
enddef

def MRUTick(bufnr: number): void
	var bufObj = LookupBuf(bufnr)
	if bufObj != v:null
		mruGroups[bufObj.groupkey] = NextMRUCounter()
		mruBuffers[bufnr] = NextMRUCounter()
	endif
enddef

def MRUPop(bufnr: number): void
	var bufObj = LookupBuf(bufnr)
	if bufObj != v:null
		if has_key(mruGroups, bufObj.groupkey)
			remove(mruGroups, bufObj.groupkey)
		endif
		if has_key(mruBuffers, bufnr)
			remove(mruBuffers, bufnr)
		endif
	endif
enddef

def MRUPush(bufnr: number): void
    # Skip temporary buffer with buftype set. Don't add the BufExplorer window
    # to the list.
    if ShouldIgnore(bufnr) == v:true
        return
    endif

    MRUTick(bufnr)
enddef

def ShouldIgnore(bufnr: number): bool
    # Ignore temporary buffers with buftype set. empty() returns 0 instead of
    # v:false for non-empty
    if empty(getbufvar(bufnr, "&buftype")) == 0
        return v:true
    endif

    # Ignore buffers with no name.
    if empty(bufname(bufnr)) == 1
        return v:true
    endif

    # Ignore the BufExplorer buffer.
    if fnamemodify(bufname(bufnr), ":t") == pluginBufName
        return v:true
    endif

    # Ignore any buffers in the exclude list.
    if index(MRU_Exclude_List, bufname(bufnr)) >= 0
        return v:true
    endif

    # Else return 0 to indicate that the buffer was not ignored.
    return v:false
enddef

def Initialize()
    SetLocalSettings()
    running = v:true
enddef

def Cleanup(): void
    if _insertmode != v:null
        &insertmode = _insertmode
    endif

    if _showcmd != v:null
        &showcmd = _showcmd
    endif

    if _cpo != v:null
        &cpo = _cpo
    endif

    if _report != v:null
        &report = _report
    endif

    running = v:false
    splitMode = ""

    delmarks!
enddef

def SetLocalSettings(): void
    _insertmode = &insertmode
    set noinsertmode

    _showcmd = &showcmd
    set noshowcmd

    _cpo = &cpo
    set cpo&vim

    _report = &report
    &report = 10000

    setlocal nonumber
    setlocal foldcolumn=0
    setlocal nofoldenable
    setlocal cursorline
    setlocal nospell
    setlocal nobuflisted
    setlocal filetype=bufexplorer
enddef

def GBufExplorerHorizontalSplit(): void
    splitMode = "sp"
    execute "GBufExplorer"
enddef

def GBufExplorerVerticalSplit(): void
    splitMode = "vsp"
    execute "GBufExplorer"
enddef

export def GToggleBufExplorer(): void
    if running == v:true && bufname(winbufnr(0)) == pluginBufName
        Close()
    else
        GBufExplorer()
    endif
enddef

def GBufExplorer(): void
    var escapedBufName = pluginBufName

    if !has("win32")
        # On non-Windows boxes, escape the name so that is shows up correctly.
        escapedBufName = escape(pluginBufName, "[]")
    endif

    # Make sure there is only one explorer open at a time.
    if running == v:true
        # Go to the open buffer.
        if has("gui")
            execute "drop" escapedBufName
        endif

        return
    endif

    # Add zero to ensure the variable is treated as a number.
    originBufNr = bufnr("%") + 0

    fileGroups = {}

    allBuffers = CollectBufferInfo()
    for bufObj in allBuffers
        var gk = bufObj.groupkey
        var grpList = []
        if has_key(fileGroups, gk)
            grpList = fileGroups[gk]
        endif
        extend(grpList, [bufObj])
        fileGroups[gk] = grpList
    endfor

    # We may have to split the current window.
    if splitMode != ""
        # Save off the original settings.
        var [_splitbelow, _splitright] = [&splitbelow, &splitright]

        # Set the setting to ours.
        [&splitbelow, &splitright] = [g:bufExplorerSplitBelow, g:bufExplorerSplitRight]
        var _size = (splitMode == "sp") ? g:bufExplorerSplitHorzSize : g:bufExplorerSplitVertSize

        # Split the window either horizontally or vertically.
        if _size <= 0
            execute 'keepalt ' .. splitMode
        else
            execute 'keepalt ' .. _size .. splitMode
        endif

        # Restore the original settings.
        [&splitbelow, &splitright] = [_splitbelow, _splitright]
    endif

    if !exists("b:displayMode") || b:displayMode != "winmanager"
        # Do not use keepalt when opening bufexplorer to allow the buffer that
        # we are leaving to become the new alternate buffer
        execute "silent keepjumps hide edit " .. escapedBufName
    endif

    DisplayBufferList()

    # Position the cursor in the newly displayed list on the line representing
    # the active buffer.  The active buffer is the line with the '%' character
    # in it.
    # execute search("%")
enddef

def DisplayBufferList(): void
    # Do not set bufhidden since it wipes out the data if we switch away from
    # the buffer using CTRL-^.
    setlocal buftype=nofile
    setlocal modifiable
    setlocal noswapfile
    setlocal nowrap

    SetupSyntax()
    MapKeys()

    # Wipe out any existing lines in case BufExplorer buffer exists and the
    # user had changed any global settings that might reduce the number of
    # lines needed in the buffer.
    silent keepjumps :1,$d _

    # setline(1, CreateHelp())
    var lines = BuildBufferLines()
    RenderBufferLines(lines)
    cursor(firstBufferLine, 1)
    normal J

    setlocal nomodifiable
enddef

def MapKeys(): void
    # nnoremap <script> <silent> <nowait> <buffer> <2-leftmouse> :call <SID>SelectBuffer()<CR>
    nnoremap <script> <silent> <nowait> <buffer> <CR>            :call <SID>SelectBuffer()<CR>
    nnoremap <script> <silent> <nowait> <buffer> J               /---.*\n\s\+\zs\d<CR>
	# TODO: With >2 groups this K movement skips the last group when wrapping.
    nnoremap <script> <silent> <nowait> <buffer> K               ?---.*\n\s\+\zs\d\(.*\n\)\+---<CR>
    # nnoremap <script> <silent> <nowait> <buffer> <F1>          :call <SID>ToggleHelp()<CR>
    # nnoremap <script> <silent> <nowait> <buffer> a             :call <SID>ToggleFindActive()<CR>
    # nnoremap <script> <silent> <nowait> <buffer> d             :call <SID>RemoveBuffer("delete")<CR>
    # xnoremap <script> <silent> <nowait> <buffer> d             :call <SID>RemoveBuffer("delete")<CR>
    # nnoremap <script> <silent> <nowait> <buffer> D             :call <SID>RemoveBuffer("wipe")<CR>
    # xnoremap <script> <silent> <nowait> <buffer> D             :call <SID>RemoveBuffer("wipe")<CR>
    # nnoremap <script> <silent> <nowait> <buffer> f             :call <SID>SelectBufferWithSplit("sb")<CR>
    # nnoremap <script> <silent> <nowait> <buffer> F             :call <SID>SelectBufferWithSplit("st")<CR>
    # nnoremap <script> <silent> <nowait> <buffer> o             :call <SID>SelectBuffer()<CR>
    nnoremap <script> <silent> <nowait> <buffer> q               :call <SID>Close()<CR>
    nnoremap <script> <silent> <nowait> <buffer> u               :call <SID>ToggleShowUnlisted()<CR>
    # nnoremap <script> <silent> <nowait> <buffer> v             :call <SID>SelectBufferWithSplit("vr")<CR>
    # nnoremap <script> <silent> <nowait> <buffer> V             :call <SID>SelectBufferWithSplit("vl")<CR>

    # for k in ["G", "n", "N", "L", "M", "H"]
    #     execute "nnoremap <buffer> <silent>" k ":keepjumps normal!" k."<CR>"
    # endfor
enddef

def SetupSyntax(): void
    if has("syntax")
        syn match GBufExHeader       /^--- .*:$/ contains=GBufExHeaderGroupKey
        syn match GBufExHeaderGroupKey /--- \zs.*\ze:$/ contained
        syn match GBufListEntry /\s\s\s\s\d\+.*$/ contains=GBufExBufNr
        syn match GBufExBufNr /\s\s\s\s\zs\d\+/ contained nextgroup=GBufExFilename skipwhite
        syn match GBufExFilename /[^\d\s].*$/ contained
    endif
enddef

# def CreateHelp(): void
#     if g:bufExplorerHelpMode == 'none'
#         return []
#     endif

#     if g:bufExplorerDefaultHelp == b:false && g:bufExplorerDetailedHelp == v:false
#         return []
#     endif

#     let header = []

#     if g:bufExplorerHelpMode == 'detailed'
#         add(header, '" Buffer Explorer ('.g:bufexplorer_version.')')
#         add(header, '" --------------------------')
#         add(header, '" <F1> : toggle this help')
#         add(header, '" <enter> or o or Mouse-Double-Click : open buffer under cursor')
#         add(header, '" <shift-enter> or t : open buffer in another tab')
#         add(header, '" a : toggle find active buffer')
#         add(header, '" b : Fast buffer switching with b<any bufnum>')
#         add(header, '" B : toggle if to save/use recent tab or not')
#         add(header, '" d : delete buffer')
#         add(header, '" D : wipe buffer')
#         add(header, '" F : open buffer in another window above the current')
#         add(header, '" f : open buffer in another window below the current')
#         add(header, '" p : toggle splitting of file and path name')
#         add(header, '" q : quit')
#         add(header, '" r : reverse sort')
#         add(header, '" R : toggle showing relative or full paths')
#         add(header, '" S : reverse cycle thru "sort by" fields')
#         add(header, '" T : toggle if to show only buffers for this tab or not')
#         add(header, '" u : toggle showing unlisted buffers')
#         add(header, '" V : open buffer in another window on the left of the current')
#         add(header, '" v : open buffer in another window on the right of the current')
#     elseif g:bufExplorerHelpMode == 'bare'
#         add(header, '" Press <F1> for Help')
#     endif

#     return header
# enddef

def InferBufferGroupKey(bufObj: dict<any>): void
	if bufObj.ftype == "link"
		var realPath = resolve(bufObj.name)
		bufObj.ftype = getftype(realPath)
	endif

    if bufObj.ftype == "dir"
        bufObj.listname = "[DIR] " .. bufObj.listname
        bufObj.groupkey = bufObj.listname
        return
    endif

    if bufObj.ftype == ""
        bufObj.listname = "[VIRTUAL] " .. fnamemodify(bufObj.name, ":t")
        bufObj.groupkey = defaultGroupKey
        return
    endif

    if bufObj.ftype != "file"
        bufObj.listname = bufObj.name
        bufObj.groupkey = bufObj.ftype
        return
    endif

    var HookFunc = get(g:, 'GroupedBufExplorerGroupingHook')
    if type(HookFunc) == 2 # 2 == Funcref
        HookFunc(bufObj)
    else
        bufObj.listname = bufObj.name
        bufObj.groupkey = defaultGroupKey
    endif
enddef

def CollectBufferInfo(): list<dict<any>>
    var bufoutput = ""
    redir => bufoutput
    # Show all buffers including the unlisted ones. [!] tells Vim to show the
    # unlisted ones.
    silent buffers!
    redir END

    var all = []

    for nativeBufObj in getbufinfo()
        if nativeBufObj.name == ""
            continue
        endif

        if nativeBufObj.name == pluginBufName
            continue
        endif

        if bufname(nativeBufObj.bufnr) == pluginBufName
            continue
        endif

        var bufObj = {
            'bufnr': nativeBufObj.bufnr,
            'hidden': nativeBufObj.hidden,
            'listed': (nativeBufObj.listed == 1),
            'name': nativeBufObj.name,
            'loaded': nativeBufObj.loaded,
            'line': nativeBufObj.lnum,
            'ftype': getftype(nativeBufObj.name),
            }

        InferBufferGroupKey(bufObj)

        add(all, bufObj)
    endfor

    return all
enddef

def NextMRUCounter(): number
    mruCounter += 1
    return mruCounter
enddef

def GetBufGroupKey(bufnr: number): string
    for bufObj in allBuffers
        if bufObj.bufnr == bufnr
            return bufObj.groupkey
        endif
    endfor
    return getbufvar(bufnr, 'bufExplorerGroupKey')
enddef

def GetBufGroupKeyOrDefault(bufnr: number): string
    var gk = GetBufGroupKey(bufnr)
    if gk == ""
        return defaultGroupKey
    endif
    return gk
enddef

def FocalBufGroupKey(): string
    if originBufNr == v:null
        return defaultGroupKey
    endif

    return GetBufGroupKeyOrDefault(originBufNr)
enddef

def BuildGroupHeaderLine(gk: string): string
    return "--- " .. gk .. ":"
enddef

def CalcFieldWidths(bufList: list<dict<any>>): list<number>
    var widths = [0, 0]
    for bufObj in bufList
        widths[0] = max([widths[0], strcharlen("" .. bufObj.bufnr)])
        widths[1] = max([widths[1], strcharlen("" .. bufObj.listname)])
    endfor
    return widths
enddef

def BuildBufferListLine(bufObj: dict<any>, w: list<number>): string
    var fieldFmtStr = "    %" .. w[0] .. "S %S"
    return printf(fieldFmtStr, bufObj.bufnr, bufObj.listname)
enddef

def BuildGroupBufferLines(grpList: list<dict<any>>): list<string>
    var tmpGrpList = copy(grpList)
    sort(tmpGrpList, (idx, bufObj) => get(mruBuffers, bufObj.bufnr, 0) - get(mruBuffers, bufObj.bufnr, 0))
    var lines = []

    var widths = CalcFieldWidths(grpList)

    for bufObj in grpList
        if !g:bufExplorerShowUnlisted && bufObj.listed == v:false
            continue
        endif

        if g:bufExplorerShowNoName == 0 && bufObj.name == noNamePlaceholder
            continue
        endif

        if bufObj.name == pluginBufName
            continue
        endif

        add(lines, BuildBufferListLine(bufObj, widths))
    endfor
    return lines
enddef

def BuildBufferLines(): list<string>
    var lines = []

    var groupKeys = keys(fileGroups)
    sort(groupKeys, (a, b) => get(mruGroups, a, 0) - get(mruGroups, b, 0))
    reverse(groupKeys)

    for gk in groupKeys
        var grpLines = BuildGroupBufferLines(fileGroups[gk])
        if len(grpLines) > 0
            add(lines, BuildGroupHeaderLine(gk))
            extend(lines, grpLines)
            add(lines, "")
        endif
    endfor

    return lines
enddef

def RenderBufferLines(lines: list<string>): void
    setline(firstBufferLine, lines)
enddef

export def SelectBuffer(): void
    # Sometimes messages are not cleared when we get here so it looks like an
    # error has occurred when it really has not.
    #echo ""

    var _bufNbr = -1

    # Are we on a line with a file name?
    if line('.') < firstBufferLine
        execute "normal! \<CR>"
        return
    endif

    # Works because str2nr ignores everything after the initial seried of digits.
    _bufNbr = str2nr(getline('.'))

    echo "Launching into buffer " .. _bufNbr
    if bufexists(_bufNbr)
        if bufnr("#") == _bufNbr && !exists("g:bufExplorerChgWin")
            Close()
            return
        endif

        # Default, open in current window
        if bufloaded(_bufNbr) && g:bufExplorerFindActive
            if g:bufExplorerFindActive
                Close()
            endif

            #Nope, the buffer is not in a tab. Simply switch to that
            #buffer.
            var _bufName = expand("#" .. _bufNbr .. ":p")
            execute _bufName != "" ? "drop " .. escape(_bufName, " ") : "buffer " .. _bufNbr
        endif

        # Switch to the selected buffer.
        execute "keepjumps keepalt silent b!" _bufNbr

        # Make the buffer 'listed' again.
        setbufvar(_bufNbr, "&buflisted", 1)

        # Call any associated function references. g:bufExplorerFuncRef may be
        # an individual function reference or it may be a list containing
        # function references. It will ignore anything that's not a function
        # reference.
        #
        # See  :help FuncRef  for more on function references.
        if exists("g:BufExplorerFuncRef")
            if type(g:BufExplorerFuncRef) == 2
                keepj g:BufExplorerFuncRef()
            elseif type(g:BufExplorerFuncRef) == 3
                for FncRef in g:BufExplorerFuncRef
                    if type(FncRef) == 2
                        keepj FncRef()
                    endif
                endfor
            endif
        endif
    else
        Error("Sorry, that buffer no longer exists, please select another")
        DeleteBuffer(_bufNbr, "wipe")
    endif
enddef

def RemoveBuffer(mode: string): void
    # Are we on a line with a file name?
    if line('.') < firstBufferLine
        return
    endif

    var realMode = mode

    var _bufNbr = str2nr(getline('.'))

    if getbufvar(_bufNbr, '&modified') == 1
        # Calling confirm() requires Vim built with dialog option
        if !has("dialog_con") && !has("dialog_gui")
            Error("Sorry, no write since last change for buffer " .. _bufNbr .. " unable to delete")
            return
        endif

        var answer = confirm("No write since last change for buffer " .. _bufNbr .. ". Delete anyway?", "&Yes\n&No", 2)

        if mode == "delete" && answer == 1
            realMode = "force_delete"
        elseif mode == "wipe" && answer == 1
            realMode = "force_wipe"
        else
            return
        endif

    endif

    # Okay, everything is good, delete or wipe the buffer.
    DeleteBuffer(_bufNbr, realMode)
enddef

def DeleteBuffer(bufnr: number, mode: string): void
    # This routine assumes that the buffer to be removed is on the current line.
    try
        # Wipe/Delete buffer from Vim.
        if mode == "wipe"
            execute "silent bwipe" bufnr
        elseif mode == "force_wipe"
            execute "silent bwipe!" bufnr
        elseif mode == "force_delete"
            execute "silent bdelete!" bufnr
        else
            execute "silent bdelete" bufnr
        endif

        # Delete the buffer from the list on screen.
        setlocal modifiable
        normal! "_dd
        setlocal nomodifiable

        # Delete the buffer from the raw buffer list.
        filter(allBuffers, (idx, bufObj) => bufObj.bufnr != bufnr)
    catch
        Error(v:exception)
    endtry
enddef

def Close(): void
    # If we needed to split the main window, close the split one.
    if splitMode != "" && bufwinnr(originBufNr) != -1
        execute "wincmd c"
    endif

	# Clear any message that may be left behind
    echo
	execute "keepjumps silent b " .. originBufNr
	return
enddef

def ToggleShowUnlisted()
    g:bufExplorerShowUnlisted = !g:bufExplorerShowUnlisted
    RebuildBufferList()
enddef

# function! s:ToggleFindActive()
#     let g:bufExplorerFindActive = !g:bufExplorerFindActive
#     call s:UpdateHelpStatus()
# endfunction

def RebuildBufferList(): void
    var lines = BuildBufferLines()
    setlocal modifiable
    normal ggdG
    RenderBufferLines(lines)
    cursor(firstBufferLine, 1)
    setlocal nomodifiable
enddef

# function! s:UpdateHelpStatus()
#     setlocal modifiable

#     let text = s:GetHelpStatus()
#     call setline(firstBufferLine - 2, text)

#     setlocal nomodifiable
# endfunction

# Display a message using ErrorMsg highlight group.
def Error(msg: string): void
    echohl ErrorMsg
    echomsg msg
    echohl None
enddef

# Display a message using WarningMsg highlight group.
def Warning(msg: string): void
    echohl WarningMsg
    echomsg msg
    echohl None
enddef

Set("g:bufExplorerDefaultHelp", 1)               # Show default help?
Set("g:bufExplorerDetailedHelp", v:false)              # Show detailed help?
Set("g:bufExplorerFindActive", v:true)                # When selecting an active buffer, take you to the window where it is active?
Set("g:bufExplorerShowDirectories", 1)           # (Dir's are added by commands like ':e .')
Set("g:bufExplorerShowUnlisted", v:false)              # Show unlisted buffers?
Set("g:bufExplorerShowNoName", 0)                # Show 'No Name' buffers?
Set("g:bufExplorerSplitBelow", &splitbelow)      # Should horizontal splits be below or above current window?
Set("g:bufExplorerSplitRight", &splitright)      # Should vertical splits be on the right or left of current window?
Set("g:bufExplorerSplitVertSize", 0)             # Height for a vertical split. If <=0, default Vim size is used.
Set("g:bufExplorerSplitHorzSize", 0)             # Height for a horizontal split. If <=0, default Vim size is used.

defcompile

augroup GroupedBufExplorer
    autocmd!
    autocmd! VimEnter * GBufExplorerSetup()
augroup END

# vim:ft=vim foldmethod=marker sw=4

