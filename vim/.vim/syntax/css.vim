" Vim syntax file
" Language:	CSS 3
" Original Author: lepture <sopheryoung@gmail.com> , 
" Claudio Fleiner <claudio@fleiner.com>
" Modify By: fremff <claffar@hotmail.com>
" Last Change:	Oct 30, 2012

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'css'
endif

syn case ignore

syn keyword cssTagName abbr acronym address applet area a b base
syn keyword cssTagName basefont bdo big blockquote body br button
syn keyword cssTagName caption center cite code col colgroup dd del
syn keyword cssTagName dfn dir div dl dt em fieldset font form frame
syn keyword cssTagName frameset h1 h2 h3 h4 h5 h6 head hr html i
syn keyword cssTagName iframe img input ins isindex kbd label legend li
syn keyword cssTagName link map menu meta noframes noscript ol optgroup
syn keyword cssTagName option p param pre q s samp script select small
syn keyword cssTagName span strike strong style sub sup tbody td
syn keyword cssTagName textarea tfoot th thead title tr tt ul u var
syn match cssTagName "\<table\>"
syn match cssTagName "\*"

" HTML 5 tags
syn keyword cssTagName article aside audio bdi bb canvas command
syn keyword cssTagName date datagrid datalist details dialog embed eventsource
syn keyword cssTagName figure figcaption footer header hgroup keygen
syn keyword cssTagName mark meter nav object output progress rp rt ruby
syn keyword cssTagName section source summary time track video wbr

syn match cssTagName "@page\>" nextgroup=cssPseudoClassId,cssPseudoElement,cssPseudoClassNot,cssPseudoClassLang,cssDefinition

syn match cssSelectorOp "[+>.]"
syn match cssSelectorOp2 "[~|]\?=" contained
syn region cssAttributeSelector matchgroup=cssSelectorOp start="\[" end="]" transparent contains=cssUnicodeEscape,cssSelectorOp2,cssStringQ,cssStringQQ

try
syn match cssIdentifier "#[A-Za-zÀ-ÿ_@][A-Za-zÀ-ÿ0-9_@-]*"
catch /^.*/
syn match cssIdentifier "#[A-Za-z_@][A-Za-z0-9_@-]*"
endtry


"   Conditional Group Rule:
syn match cssMedia "@media\>" nextgroup=cssMediaType,cssMediaNot,cssMediaBrackets skipwhite skipnl
syn keyword cssMediaType contained screen print aural braile embosed handheld projection ty tv all nextgroup=cssMediaComma,cssMediaBlock,cssMediaAnd skipwhite skipnl
syn match cssMediaComma contained "," nextgroup=cssMediaType skipwhite skipnl
syn region cssMediaBlock transparent matchgroup=cssBraces start='{' end='}' contains=cssTagName,cssError,cssComment,cssDefinition,cssURL,cssUnicodeEscape,cssIdentifier,cssAttributeSelector,cssPseudoClassId,cssPseudoElement,cssPseudoClassNot,cssPseudoClassLang,cssSelectorOp,cssClassName
syn match cssMediaAnd "\<and\>" contained nextgroup=cssMediaBrackets skipwhite skipnl
syn match cssMediaNot "\<not\>" contained nextgroup=cssMediaType,cssMediaBrackets skipwhite skipnl
syn region cssMediaBrackets contained start='(' end=')' contains=cssMediaNot,cssMediaAnd,cssMediaType nextgroup=cssMediaComma,cssMediaAnd,cssMediaBlock skipwhite skipnl

syn match cssValueInteger contained "[-+]\=\d\+"
syn match cssValueNumber contained "[-+]\=\d\+\(\.\d*\)\="
syn match cssValueLength contained "[-+]\=\d\+\(\.\d*\)\=\(%\|mm\|cm\|in\|pt\|pc\|em\|ex\|px\)"
syn match cssValueAngle contained "[-+]\=\d\+\(\.\d*\)\=\(deg\|grad\|rad\)"
syn match cssValueTime contained "+\=\d\+\(\.\d*\)\=\(ms\|s\)"
syn match cssValueFrequency contained "+\=\d\+\(\.\d*\)\=\(Hz\|kHz\)"

syn match cssFontDescriptor "@font-face\>" nextgroup=cssFontDescriptorBlock skipwhite skipnl
syn region cssFontDescriptorBlock contained transparent matchgroup=cssBraces start="{" end="}" contains=cssComment,cssError,cssUnicodeEscape,cssFontProp,cssFontAttr,cssCommonAttr,cssStringQ,cssStringQQ,cssFontDescriptorProp,cssValue.*,cssFontDescriptorFunction,cssUnicodeRange,cssFontDescriptorAttr,cssImportant
syn match cssFontDescriptorProp contained "\<\(unicode-range\|unit-per-em\|panose-1\|cap-height\|x-height\|definition-src\)\>\(\s*:\)\@="
syn keyword cssFontDescriptorProp contained src stemv stemh slope ascent descent widths bbox baseline centerline mathline topline
syn keyword cssFontDescriptorAttr contained all
syn region cssFontDescriptorFunction contained matchgroup=cssFunctionName start="\<\(uri\|url\|local\|format\)\s*(" end=")" contains=cssStringQ,cssStringQQ oneline keepend
syn match cssUnicodeRange contained "U+[0-9A-Fa-f?]\+"
syn match cssUnicodeRange contained "U+\x\+-\x\+"

syn keyword cssColor contained aqua black blue fuchsia gray green lime maroon navy olive purple red silver teal yellow
" FIXME: These are actually case-insensitive too, but (a) specs recommend using
" mixed-case (b) it's hard to highlight the word `Background' correctly in
" all situations
syn case match
syn keyword cssColor contained ActiveBorder ActiveCaption AppWorkspace ButtonFace ButtonHighlight ButtonShadow ButtonText CaptionText GrayText Highlight HighlightText InactiveBorder InactiveCaption InactiveCaptionText InfoBackground InfoText Menu MenuText Scrollbar ThreeDDarkShadow ThreeDFace ThreeDHighlight ThreeDLightShadow ThreeDShadow Window WindowFrame WindowText Background
syn case ignore
syn match cssColor contained "\<transparent\>"
syn match cssColor contained "\<white\>"
syn match cssColor contained "#[0-9A-Fa-f]\{3\}\>"
syn match cssColor contained "#[0-9A-Fa-f]\{6\}\>"
"syn match cssColor contained "\<rgb\s*(\s*\d\+\(\.\d*\)\=%\=\s*,\s*\d\+\(\.\d*\)\=%\=\s*,\s*\d\+\(\.\d*\)\=%\=\s*)"
"syn region cssURL contained matchgroup=cssFunctionName start="\<url\s*(" end=")" oneline keepend
syn region cssFunction contained matchgroup=cssFunctionName start="\<\(clip\|attr\|counter\|rect\)\s*(" end=")" oneline keepend
"syn region cssColor contained start="\<\(rgb\|rgba\|hsl\|hsla\)\s*("ms=e+1 end=")"me=s-1 oneline
syn region cssColor contained matchgroup=cssFunctionName start="\<\(rgb\|rgba\|hsl\|hsla\)\s*(" end=")" oneline keepend
syn region cssFunction transparent contained matchgroup=cssFunctionName start="\(-\(moz\|webkit\|ms\|o\)-\|\)\(linear\|radial\)-gradient\s*(" skip="," end=")" oneline skipwhite
syn region cssFunction transparent contained matchgroup=cssFunctionName start="\<-moz-image-rect\s*(" skip="," end=")" oneline skipwhite
"syn region cssFunction contained matchgroup=cssFunctionName start="\<\(matrix\(3d\)\=\|scale\(3d\|X\|Y|\Z\)\=\|translate\(3d\|X\|Y|\Z\)\=\|skew\(X\|Y\)\=\|rotate\(3d\|X\|Y|\Z\)\=\)\s*(" end=")" oneline keepend
"syn region cssFunction contained matchgroup=cssFunctionName start="\<cubic-bezier\s*(" end=")" oneline keepend

syn match cssImportant contained "!\s*important\>"

syn keyword cssCommonAttr contained auto none inherit
syn match cssCommonAttr contained "\<\(top\|bottom\|left\|right\)\(:\)\@!"
syn keyword cssCommonAttr contained medium normal

syn match cssFontProp contained "\<font\(-\(family\|style\|variant\|weight\|size\(-adjust\)\=\|stretch\)\)\=\>\(\s*:\)\@="
syn match cssFontAttr contained "\<\(sans-\)\=serif\>"
syn match cssFontAttr contained "\<small\(-\(caps\|caption\)\)\=\>"
syn match cssFontAttr contained "\<x\{1,2\}-\(large\|small\)\>"
syn match cssFontAttr contained "\<message-box\>"
syn match cssFontAttr contained "\<status-bar\>"
syn match cssFontAttr contained "\<\(\(ultra\|extra\|semi\|status-bar\)-\)\=\(condensed\|expanded\)\>"
syn keyword cssFontAttr contained cursive fantasy monospace italic oblique
syn keyword cssFontAttr contained bold bolder lighter larger smaller
syn keyword cssFontAttr contained icon menu
syn match cssFontAttr contained "\<caption\>"
syn keyword cssFontAttr contained large
syn keyword cssFontAttr contained narrower wider

syn keyword cssColorProp contained color
syn keyword cssColorAttr contained center scroll fixed
syn match cssColorAttr contained "\<repeat\(-[xy]\)\=\>"
syn match cssColorAttr contained "\<no-repeat\>"

syn match cssTextProp "\<\(\(word\|letter\)-spacing\|text\(-\(decoration\|transform\|align\|index\|shadow\|rendering\)\)\=\|vertical-align\|unicode-bidi\|line-height\)\>\(\s*:\)\@="
syn match cssTextAttr contained "\<line-through\>"
syn match cssTextAttr contained "\<text-indent\>"
syn match cssTextAttr contained "\<\(text-\)\=\(top\|bottom\)\>"
syn keyword cssTextAttr contained underline overline blink sub super middle
syn keyword cssTextAttr contained capitalize uppercase lowercase center justify baseline sub super

syn match cssBoxProp contained "\<\(margin\|padding\|border\)\(-\(top\|right\|bottom\|left\)\)\=\>\(\s*:\)\@="
syn match cssBoxProp contained "\<border-\(\(\(top\|right\|bottom\|left\)-\)\=\(width\|color\|style\)\)\=\>\(\s*:\)\@="
syn match cssBoxProp contained "\<\(width\|z-index\)\>\(\s*:\)\@="
syn match cssBoxProp contained "\<\(min\|max\)-\(width\|height\)\>\(\s*:\)\@="
syn match cssBoxProp contained "\<\(width\|height\|float\|clear\|overflow\|clip\|visibility\)\>\(\s*:\)\@="
syn keyword cssBoxAttr contained thin thick both
syn keyword cssBoxAttr contained dotted dashed solid double groove ridge inset outset
syn keyword cssBoxAttr contained hidden visible scroll collapse

syn keyword cssGeneratedContentProp contained content quotes
syn match cssGeneratedContentProp contained "\<counter-\(reset\|increment\)\>\(\s*:\)\@="
syn match cssGeneratedContentProp contained "\<list-style\(-\(type\|position\|image\)\)\=\>\(\s*:\)\@="
syn match cssGeneratedContentAttr contained "\<\(no-\)\=\(open\|close\)-quote\>"
syn match cssAuralAttr contained "\<lower\>"
syn match cssGeneratedContentAttr contained "\<\(lower\|upper\)-\(roman\|alpha\|greek\|latin\)\>"
syn match cssGeneratedContentAttr contained "\<\(hiragana\|katakana\)\(-iroha\)\=\>"
syn match cssGeneratedContentAttr contained "\<\(decimal\(-leading-zero\)\=\|cjk-ideographic\)\>"
syn keyword cssGeneratedContentAttr contained disc circle square hebrew armenian georgian
syn keyword cssGeneratedContentAttr contained inside outside

syn match cssPagingProp contained "\<page\(-break-\(before\|after\|inside\)\)\=\>\(\s*:\)\@="
syn keyword cssPagingProp contained size marks inside orphans widows
syn keyword cssPagingAttr contained landscape portrait crop cross always avoid

syn keyword cssUIProp contained cursor
syn match cssUIAttr contained "\<[ns]\=[ew]\=-resize\>"
syn keyword cssUIAttr contained default crosshair pointer move wait help
syn keyword cssUIAttr contained thin thick
syn keyword cssUIAttr contained dotted dashed solid double groove ridge inset outset
syn keyword cssUIAttr contained invert

syn match cssRenderAttr contained "\<marker\>"
syn match cssRenderProp contained "\<\(display\|marker-offset\|unicode-bidi\|white-space\|list-item\|run-in\|inline-table\)\>\(\s*:\)\@="
syn keyword cssRenderProp contained position direction
syn match cssRenderProp contained "\<\(top\|bottom\)\>\(\s*:\)\@="
syn match cssRenderProp contained "\<\(left\|right\)\>\(\s*:\)\@="
syn keyword cssRenderAttr contained block inline compact
syn match cssRenderAttr contained "\<table\(-\(\(header\|footer\)-group\|\(row\|column\)\(-group\)\=\|cell\|caption\)\)\=\>"
syn keyword cssRenderAttr contained static relative absolute fixed
syn keyword cssRenderAttr contained ltr rtl embed bidi-override pre nowrap pre-wrap pre-line
syn match cssRenderAttr contained "\<bidi-override\>"


syn match cssAuralProp contained "\<\(pause\|cue\)\(-\(before\|after\)\)\=\>\(\s*:\)\@="
syn match cssAuralProp contained "\<\(play-during\|speech-rate\|voice-family\|pitch\(-range\)\=\|speak\(-\(punctuation\|numerals\)\)\=\)\>\(\s*:\)\@="
syn keyword cssAuralProp contained volume during azimuth elevation stress richness
syn match cssAuralAttr contained "\<\(x-\)\=\(soft\|loud\)\>"
syn keyword cssAuralAttr contained silent
syn match cssAuralAttr contained "\<spell-out\>"
syn keyword cssAuralAttr contained non mix
syn match cssAuralAttr contained "\<\(left\|right\)-side\>"
syn match cssAuralAttr contained "\<\(far\|center\)-\(left\|center\|right\)\>"
syn keyword cssAuralAttr contained leftwards rightwards behind
syn keyword cssAuralAttr contained below level above higher
syn match cssAuralAttr contained "\<\(x-\)\=\(slow\|fast\)\>"
syn keyword cssAuralAttr contained faster slower
syn keyword cssAuralAttr contained male female child code digits continuous

syn match cssTableProp contained "\<\(caption-side\|table-layout\|border-collapse\|border-spacing\|empty-cells\|speak-header\)\>\(\s*:\)\@="
syn keyword cssTableAttr contained fixed collapse separate show hide once always

" HTML 5 Attribute
syn keyword cssCommonAttr contained contenteditable contextmenu draggable item
syn keyword cssCommonAttr contained itemprop list subject spellcheck dropzone 

" CSS3
" User-interface
syn match cssUIProp contained "\<nav-\(index\|up\|right\|down\|left\)\>\(\s*:\)\@="
syn keyword cssUIProp contained resize
" Other modules
syn match cssBoxProp contained "\(-\(moz\|webkit\)-\|\)column-\(width\|rule\(-\(color\|width\|style\)\)\=\|gap\|count\|span\)\>\(\s*:\)\@="
syn match cssBoxProp contained "\(-moz-\)\=column-fill\>\(\s*:\)\@="
syn match cssBoxProp contained "\(-\(moz\|webkit\)-\|\)columns\>\(\s*:\)\@="
syn match cssBoxProp contained "\<column-break-\(after\|before\)\>\(\s*:\)\@="

syn match cssColorProp contained "\<opacity\>\(\s*:\)\@="

syn match cssGeneratedContentProp contained "\<background\(-\(origin\|clip\|repeat\|color\|image\|attachment\|position\|size\)\)\=\>\(\s*:\)\@="

syn match cssBoxProp contained "\(-\(webkit\|o\)-\|\)\(-moz-\)\@<!border-image\>\(\s*:\)\@="
syn match cssBoxProp contained "\<border-radius\>\(\s*:\)\@="
syn match cssBoxProp contained "\<border-\(bottom\|top\)-\(left\|right\)-radius\>\(\s*:\)\@="

syn match cssTextProp contained "\<text-\(justify\|\outline\|overflow\|warp\|indent\)\>\(\s*:\)\@="
syn match cssRenderProp contained "\(-\(webkit\)-\|\)\(-\(moz\|ms\|o\)-\)\@<!transform\(-\(origin\|style\)\)\=\>\(\s*:\)\@="
syn match cssTextProp contained "\<word-\(break\|\wrap\)\>\(\s*:\)\@="
syn match cssRenderProp contained "\(-\(webkit\)-\|\)\(-\(moz\|o\)-\)\@<!transition\(-\(delay\|duration\|property\|timing-function\)\)\=\>\(\s*:\)\@="

syn match cssRenderAttr contained "\<ease\(-\(in-out\|out\|in\)\)\=\>"
syn match cssCommonAttr contained "\(-moz-\)\=initial\>"
syn keyword cssRenderAttr contained infinite linear running paused alternate
syn keyword cssRenderAttr contained forwards backwards both preserve-3d flat
syn keyword cssBoxAttr contained content-box padding-box border-box manual
syn keyword cssBoxAttr contained balance round space horizontal vertical
syn keyword cssBoxAttr contained inline-axis block-axis fill
syn keyword cssBoxAttr contained start end stretch reverse ignore stretch-to-fit
syn keyword cssTextAttr contained ellipsis clip break-word break-all keep-all
syn keyword cssTextAttr contained optimizeSpeed optimizeLegibility geometricPrecision
syn keyword cssGeneratedContentAttr contained bounding-box each-box cover contain
syn match cssTableAttr contained "\<\(flex\|grid\|inline-\(block\|table\|flex\|grid\)\|list-item\|run-in\)\>"

syn match cssBoxProp contained "\<marquee\(-\(direction\|play-count\|speed\|style\)\)\=\>\(\s*:\)\@="
syn match cssBoxProp contained "\<overflow-\(x\|y\|style\)\>\(\s*:\)\@="
syn match cssBoxProp contained "\(-webkit-\)\=\(-moz-\)\@<!perspective\(-origin\)\=\>\(\s*:\)\@="
syn match cssRenderProp contained "\(-\(webkit\)-\|\)\(-\(moz\|o\)-\)\@<!animation\(-\(fill-mode\|direction\|name\|duration\|timing-function\|delay\|iteration-cout\|play-state\)\)\=\>\(\s*:\)\@="
syn match cssUIProp contained "\(-\(moz\|webkit\)-\|\)appearance\>\(\s*:\)\@="
syn match cssBoxProp contained "\(-\(moz\|webkit\)-\|\)box-\(align\|direction\|flex\|ordinal-group\|orient\|pack\|sizing\)\>\(\s*:\)\@="
syn match cssBoxProp contained "\<box-shadow\>\(\s*:\)\@="

syn match cssBoxProp contained "\<-moz-border-\(\(top\|right\|bottom\|left\)-colors\)\>\(\s*:\)\@="
syn match cssBoxProp contained "\<border-image-\(source\|width\|repeat\|outset\|slice\)\>\(\s*:\)\@="
syn match cssBoxProp contained "\(-moz-\)\=\(\(margin\|padding\|border\)-\(end\|start\)\)\>\(\s*:\)\@="
syn match cssTextProp contained "\(-moz-\)\=text-\(align-last\|blink\)\>\(\s*:\)\@="
syn match cssTextProp contained "\(-moz-\)\=text-decoration-\(line\|color\|style\)\>\(\s*:\)\@="
syn match cssBoxProp contained "\(-\(moz\|webkit\|ms\)-\|\)hyphens\>\(\s*:\)\@="
syn match cssFontProp contained "\(-\(moz\|webkit\)-\|\)font-feature-settings\>\(\s*:\)\@="
syn match cssBoxProp contained "\(-webkit-\)\=\(-moz-\)\@<!backface-visibility\>\(\s*:\)\@="
syn match cssBoxProp contained "\(-moz-\)\=binding\>\(\s*:\)\@="
syn match cssBoxProp contained "\<-moz-orient\>\(\s*:\)\@="
syn match cssUIProp contained "\<-moz-outline-radius\(-\(bottomleft\|bottomright\|topleft\|topright\)\)\=\>\(\s*:\)\@="
syn match cssUIProp contained "\<outline\(-\(width\|style\|offset\|color\)\)\=\>\(\s*:\)\@="
syn match cssUIProp contained "\(-moz-\)\=user-\(focus\|input\|modify\)\>\(\s*:\)\@="
syn match cssUIProp contained "\<user-select\>\(\s*:\)\@="
syn match cssRenderProp contained "\(-\(webkit\)-\|\)filter\>\(\s*:\)\@="
syn match cssGeneratedContentProp contained "\<-moz-background-inline-policy\>\(\s*:\)\@="
syn match cssGeneratedContentProp contained "\<-moz-image-region\>\(\s*:\)\@="
syn match cssBoxProp contained "\<mask\>\(\s*:\)\@="
syn match cssBoxProp contained "\<clip-path\>\(\s*:\)\@="
syn match cssUIProp contained "\<pointer-events\>\(\s*:\)\@="
syn match cssBoxProp contained "\<-moz-stack-sizing\>\(\s*:\)\@="

" FIXME: This allows cssMediaBlock before the semicolon, which is wrong.
syn region cssInclude start="@import" end=";" contains=cssComment,cssURL,cssUnicodeEscape,cssMediaType,cssStringQ,cssStringQQ
syn match cssBraces contained "[{}]"
syn match cssError contained "{@<>"
syn region cssDefinition transparent matchgroup=cssBraces start='{' end='}' contains=css.*Attr,css.*Prop,cssComment,cssValue.*,cssColor,cssURL,cssImportant,cssError,cssStringQ,cssStringQQ,cssFunction,cssUnicodeEscape
syn match cssBraceError "}"

" At-rule Groups
"   Conditional Group Rule:
syn match cssDocument "@\(-moz-\)\=document\>" nextgroup=cssURL,cssURLPrefix,cssDomain,cssRegexp skipwhite skipnl 
syn region cssURLPrefix contained matchgroup=cssFunctionName start="\<url-prefix\s*(" end=")" nextgroup=cssDocumentComma,cssDocumentBlock oneline keepend skipwhite
syn region cssDomain contained matchgroup=cssFunctionName start="\<domain\s*(" end=")" nextgroup=cssDocumentComma,cssDocumentBlock oneline keepend skipwhite
syn region cssRegexp contained matchgroup=cssFunctionName start="\<regexp\s*(" skip=")\(,\?\s\)\@!" end=")" contains=cssRegexpError nextgroup=cssDocumentComma,cssDocumentBlock oneline keepend skipwhite
syn match cssDocumentComma contained "," nextgroup=cssURL,cssURLPrefix,cssDomain,cssRegexp skipwhite skipnl
syn region cssURL contained matchgroup=cssFunctionName start="\<url\s*(" end=")" nextgroup=cssDocumentComma,cssDocumentBlock oneline keepend skipwhite
syn region cssDocumentBlock contained transparent matchgroup=cssBraces start='{' end='}' contains=cssNestedSelector,cssMedia,cssFontDescriptor,cssKeyFrame,cssSupports,cssComment
syn match cssNestedSelector transparent contained "[a-zA-Z*#.][^{]*" contains=cssBracketsValue,cssPseudo.\+,cssComment,cssError,cssAttributeSelector,cssSelectorOp,cssFunction,cssUnicodeEscape,cssTagName,cssClassName,cssIdentifier nextgroup=cssDefinition skipwhite skipnl
syn match cssRegexpError contained +\(\sregexp(\)\@<=[^'"].*\(),\?\s\)\@=\|\(\sregexp(\)\@<=['][^']*\(),\?\s\)\@=\|\(\sregexp(\)\@<=["][^"]*\(),\?\s\)\@=\|\\\@<!\\[^\\]+

" Testing Group
syn match cssSupports "@supports\>" nextgroup=cssSupportsNot,cssSupportsBrackets skipwhite skipnl
syn match cssSupportsNot contained "\<not\>"  skipwhite skipnl
syn match cssSupportsAnd contained "\<and\>"  skipwhite skipnl
syn match cssSupportsOr  contained "\<or\>"   skipwhite skipnl
syn region cssSupportsBrackets contained transparent start="(" end=")" contains=css.*Prop,css.*Attr,cssValue.*,cssSupportsNot,cssSupportsAnd,cssSupportsOr,cssSupportsBrackets nextgroup=cssSupportsBlock skipwhite skipnl
syn region cssSupportsBlock contained transparent matchgroup=cssBraces start='{' end='}' contains=cssNestedSelector,cssMedia,cssFontDescriptor,cssKeyFrame,cssComment

" At-rule Groups
syn region cssNameSpace start="@namespace" end=";" contains=cssStringQ*,cssURL,cssNameSpaceName
syn match cssNameSpaceName contained "\s\@<=\<[a-zA-Z]\+\>\s\@="

syn region cssCharset start="@charset" end=";" contains=cssCharsetString
syn match cssCharsetString contained +"[a-zA-Z][a-zA-Z0-9-]*"+

" At-rule Group of Testing
syn match cssKeyFrame "@\(-webkit-\)\=\(-\(moz\|o\)-\)\@<!keyframes\>" nextgroup=cssKeyFrameID skipwhite skipnl
syn match cssKeyFrameID contained "\<[a-zA-Z]\+\>" nextgroup=cssKeyFrameBlock skipwhite skipnl
syn region cssKeyFrameBlock transparent contained matchgroup=cssBraces start="{" end="}" contains=cssKeyFrameTime
syn match cssKeyFrameTime contained "\<\(from\|to\|\d\+%\)\>" nextgroup=cssDefinition skipwhite skipnl


"syn match cssPseudoClass ":\(\S\({\|,\)\@!\)*" contains=cssPseudoClassId,cssPseudoElement,cssUnicodeEscape,cssClassName,cssSelectorOp2,cssSelectorOp,cssStringQQ,cssTagName,cssBracketsValue
syn match cssPseudoClassId ":\(link\|visited\|active\|hover\|focus\|first\|left\|right\)\>"
syn match cssPseudoElement "\(:\)\=:\(before\|after\|first-letter\|first-line\|selection\)\>"
syn region cssPseudoClassLang matchgroup=cssPseudoClassId start=":lang(" end=")" oneline

" PseudoClass expansion list
syn match cssPseudoClassId ":\(first\|last\|only\)-\(of-type\|child\)\>"
syn match cssPseudoClassId ":\(nth\|nth-last\)-\(of-type\|child\)\>" nextgroup=cssBracketsValue
syn match cssPseudoClassId ":\(root\|empty\|target\|enabled\|disabled\|checked\)\>"
syn match cssPseudoClassId ":\(-\(moz\|webkit\)-\|\)any\>"
syn region cssPseudoClassNot matchgroup=cssPseudoClassId start=":not(" end=")" contains=cssAttributeSelector,cssSelectorOp2,cssStringQQ oneline
syn match cssBracketsValue "\(:nth-\(\(last-\)\=child\|\(last-\)\=of-type\)(\)\@<=\(-\=\(\d\+\(n\)\=\|n\)\(+\d\+\)\=\|odd\|even\)\()\)\@="

syn region cssComment start="/\*" end="\*/" contains=@Spell

syn match cssUnicodeEscape "\\\x\{1,6}\s\?"
syn match cssSpecialCharQQ +\\"+ contained
syn match cssSpecialCharQ +\\'+ contained
syn region cssStringQQ start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=cssUnicodeEscape,cssSpecialCharQQ
syn region cssStringQ start=+'+ skip=+\\\\\|\\'+ end=+'+ contains=cssUnicodeEscape,cssSpecialCharQ
syn match cssClassName "\.[A-Za-z][A-Za-z0-9_-]\+"


if main_syntax == "css"
  syn sync minlines=10
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_css_syn_inits")
  if version < 508
    let did_css_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink cssComment Comment
  HiLink cssTagName Statement
  HiLink cssSelectorOp Special
  HiLink cssSelectorOp2 Special
  HiLink cssFontProp StorageClass
  HiLink cssColorProp StorageClass
  HiLink cssTextProp StorageClass
  HiLink cssBoxProp StorageClass
  HiLink cssRenderProp StorageClass
  HiLink cssAuralProp StorageClass
  HiLink cssRenderProp StorageClass
  HiLink cssGeneratedContentProp StorageClass
  HiLink cssPagingProp StorageClass
  HiLink cssTableProp StorageClass
  HiLink cssUIProp StorageClass
  HiLink cssFontAttr Type
  HiLink cssColorAttr Type
  HiLink cssTextAttr Type
  HiLink cssBoxAttr Type
  HiLink cssRenderAttr Type
  HiLink cssAuralAttr Type
  HiLink cssGeneratedContentAttr Type
  HiLink cssPagingAttr Type
  HiLink cssTableAttr Type
  HiLink cssUIAttr Type
  HiLink cssCommonAttr Type
  HiLink cssPseudoClassId PreProc
  HiLink cssPseudoElement PreProc
  HiLink cssPseudoClassLang Constant
  HiLink cssValueLength Number
  HiLink cssValueInteger Number
  HiLink cssValueNumber Number
  HiLink cssValueAngle Number
  HiLink cssValueTime Number
  HiLink cssValueFrequency Number
  HiLink cssFunction Constant
  HiLink cssURL String
  HiLink cssFunctionName Function
  HiLink cssColor Constant
  HiLink cssIdentifier Function
  HiLink cssInclude Include
  HiLink cssImportant Special
  HiLink cssBraces Function
  HiLink cssBraceError Error
  HiLink cssError Error
  HiLink cssInclude Include
  HiLink cssUnicodeEscape Special
  HiLink cssStringQQ String
  HiLink cssStringQ String
  HiLink cssMedia Statement
  HiLink cssMediaType Special
  HiLink cssMediaComma Normal
  HiLink cssFontDescriptor Statement
  HiLink cssFontDescriptorFunction Constant
  HiLink cssFontDescriptorProp StorageClass
  HiLink cssFontDescriptorAttr Type
  HiLink cssUnicodeRange Constant
  HiLink cssClassName Function
  HiLink cssBracketsValue Number
  HiLink cssMediaAnd Operator
  HiLink cssMediaNot Operator
  HiLink cssURLPrefix String
  HiLink cssDomain String
  HiLink cssRegexp String
  HiLink cssRegexpError Error
  HiLink cssCharsetString String

  delcommand HiLink
endif

let b:current_syntax = "css"

if main_syntax == 'css'
  unlet main_syntax
endif
