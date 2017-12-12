
syn keyword plantKeywords actor boundary database entity

syn match plantBoundaryDecl /@startuml/
syn match plantBoundaryDecl /@enduml/
syn keyword plantKeyword note end
" syn region plantDocument start='@startuml' end='@enduml' contains=plantUseCase,plantNote,plantUseCaseTitle,plantActorName
syn match plantRightArrow /[-]\+>/
syn match plantLeftArrow /<[-]\+/
syn match plantActorName /:[A-Za-z0-9 ]\+:/
syn match plantUseCaseTitle /([A-Za-z0-9 ]\+)/
syn match plantAlias / as ([A-Za-z0-9]\+)/hs=s+4
syn match plantAlias / as [A-Za-z0-9]\+/hs=s+4
syn region plantNote start=+^note+ end=+^end note+ keepend transparent contains=plantUseCaseTitle



hi plantNote guifg=LightGreen
hi plantKeyword guifg=Orange
hi plantBoundaryDecl guifg=Orange
hi plantActorName guifg=Blue
hi plantUseCaseTitle guifg=DarkGreen
hi plantAlias guifg=Yellow
hi plantLeftArrow guifg=Cyan
hi plantRightArrow guifg=Cyan
hi plantKeywords guifg=Yellow
