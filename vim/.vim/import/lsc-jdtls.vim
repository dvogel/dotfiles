vim9script

def FixEdit(idx: number, maybeEdit: any): any
    if type(maybeEdit) != v:t_dict
        echomsg "Unexpected maybeEdit: " .. string(maybeEdit)
        return maybeEdit
    endif

    if !has_key(maybeEdit, 'command') ||
                \ !has_key(maybeEdit.command, 'command') ||
                \ maybeEdit.command.command !=# 'java.apply.workspaceEdit'
        return maybeEdit
    endif
    return {
                \ 'edit': maybeEdit.command.arguments[0],
                \ 'title': maybeEdit.command.title}
enddef

# Turn the invalid java.apply.workspaceEdit commands into an edit
# action which complies with the LSP spec
def FixEdits(actions: any): any
    return map(actions, function(FixEdit))
enddef

# def LogAction(actions: any): any
#     echomsg "actions: " .. string(actions)
#     return actions
# enddef

export def ReinitializeJdtlsLscIntegration(): void
    var jdtls_path = expand('~/bin/jdtls')
    if executable(jdtls_path)
        extend(g:lsc_server_commands, {
            \ 'java': {
                \ 'command': jdtls_path .. " " .. expand("~/opt/eclipse.jdt.ls"),
                \ 'response_hooks': {
                \        'textDocument/codeAction': function(FixEdits),
                    \    }
                \ }
            \ })
    endif
enddef

defcompile

g:ReinitializeJdtlsLscIntegration = function(ReinitializeJdtlsLscIntegration)

