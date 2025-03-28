vim9script

var localAutoCompleteFile = getenv('HOME') .. '/vim-local-autocomplete.txt'
appendoption#AppendAutoCompleteFilePathIfExists(localAutoCompleteFile)

