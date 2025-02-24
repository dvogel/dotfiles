function! ToggleLspOption(optName) abort
    let l:opts = LspOptionsGet()
    if has_key(l:opts, a:optName)
        if l:opts[a:optName]
            let l:opts[a:optName] = v:false
        else
            let l:opts[a:optName] = v:true
        endif
        call LspOptionsSet(l:opts)
    endif
endfunction

" Wraps our options to make them easier to update.
function! SetLspOptionsAgain() abort
    call LspOptionsSet(#{
                \   aleSupport: v:false,
                \   autoComplete: v:false,
                \   autoHighlight: v:false,
                \   autoHighlightDiags: v:true,
                \   autoPopulateDiags: v:true,
                \   completionMatcher: 'case',
                \   completionTextEdit: v:true,
                \   completionKinds: {},
                \   customCompletionKinds: v:false,
                \   diagSignErrorText: 'E>',
                \   diagSignInfoText: 'I>',
                \   diagSignHintText: 'H>',
                \   diagSignWarningText: 'W>',
                \   diagVirtualTextAlign: 'above',
                \   echoSignature: v:true,
                \   hideDisabledCodeActions: v:false,
                \   highlightDiagInline: v:false,
                \   hoverInPreview: v:false,
                \   ignoreMissingServer: v:false,
                \   keepFocusInReferences: v:false,
                \   noNewlineInCompletion: v:true,
                \   omniComplete: v:true,
                \   outlineOnRight: v:true,
                \   outlineWinSize: 40,
                \   showDiagInBalloon: v:true,
                \   showDiagInPopup: v:true,
                \   showDiagOnStatusLine: v:true,
                \   showDiagWithSign: v:true,
                \   showDiagWithVirtualText: v:false,
                \   showInlayHints: v:true,
                \   showSignature: v:true,
                \   snippetSupport: v:false,
                \   ultisnipsSupport: v:false,
                \   usePopupInCodeAction: v:true,
                \   useQuickfixForLocations: v:true,
                \   useBufferCompletion: v:true,
                \ })
endfunction
augroup LspInit
    autocmd VimEnter * call SetLspOptionsAgain()
    autocmd BufReadPre *.go,*.rs,*.js,*.ts call SetLspOptionsAgain()
augroup END
nmap <silent> <C-S-i> :call ToggleLspOption("highlightDiagInline") \| :echo "Inline type hints will change after the next save."<CR>

if executable('gopls')
    call LspAddServer([#{
                \    name: 'go',
                \    filetype: ['go'],
                \    path: exepath('gopls'),
                \    args: [],
                \    syncInit: v:true
                \  }])
endif

if executable('rust-analyzer')
    call LspAddServer([#{
                \    name: 'rustlang',
                \    filetype: ['rust'],
                \    path: exepath('rust-analyzer'),
                \    args: [],
                \    syncInit: v:true,
                \    initializationOptions: {
                \        "rust-analyzer.completion.autoimport.enable": v:true,
                \        "rust-analyzer.check.ignore": ["unused_imports", "unused_variables"]
                \    }
                \  }])
endif

if executable('start-typescript-language-server')
    call LspAddServer([#{
                \    name: 'typescript-language-server',
                \    filetype: ['typescript'],
                \    path: exepath('start-typescript-language-server'),
                \    args: [],
                \    syncInit: v:true,
                \    initializationOptions: {
                \    }
                \  }])
endif

nmap <M-c> :LspCodeAction<CR>
nmap <M-d> :LspDiagCurrent<CR>
nmap <M-h> :LspHover<CR>
nmap <M-r> :LspRename<CR>
nmap <M-s> :LspShowSignature<CR>
