" https://jira.atlassian.com/secure/WikiRendererHelpAction.jspa?section=all
syn case ignore
syn sync fromstart

syn match jiraTODO "TODO:"
syn region jiraQuoteBlock matchgroup=jiraQuoteBlockTags start="{quote}" end="{quote}"
syn region jiraNoFormatBlock matchgroup=jiraNoFormatBlockTags start="{noformat}" end="{noformat}"
syn region jiraMonoSpan matchgroup=jiraMonoSpanTags start="{{" end="}}"
syn region jiraEmphasisSpan matchgroup=jiraEmphasisSpanTags start="_" end="_"
syn region jiraStrongSpan matchgroup=jiraStrongSpanTags start="*" end="*"
syn match jiraListLine "^\([*]\+\|[-]\+\).*$" contains=jiraListBullet
syn match jiraListBullet "^\([*]\+\|[-]\+\)"
syn region jiraHeader matchgroup=jiraHeaderDecl start="^h[1-6][.]" end="$"
syn region jiraBlockQuote matchgroup=jiraBlockQuoteDecl start="^bq[.]" end="$" 

highlight jiraQuoteBlock guifg=drew_midgray gui=italic
highlight jiraQuoteBlockTags guifg=drew_orange
highlight jiraNoFormatBlock guifg=drew_birchwood
highlight jiraNoFormatBlockTags guifg=drew_orange
highlight jiraMonoSpan guifg=drew_birchwood
highlight jiraMonoSpanTags guifg=drew_orange
highlight jiraEmphasisSpan gui=italic
highlight jiraEmphasisSpanTags guifg=drew_orange
highlight jiraStrongSpan gui=bold
highlight jiraStrongSpanTags guifg=drew_orange
highlight jiraListBullet guifg=drew_barbiepink gui=bold
highlight jiraHeader guifg=drew_slategreen gui=bold
highlight jiraHeaderDecl guifg=drew_barbiepink gui=bold
highlight jiraBlockQuote guifg=drew_midgray gui=italic
highlight jiraBlockQuoteDecl guifg=drew_barbiepink gui=bold
highlight jiraTODO guifg=drew_watermelon gui=bold

