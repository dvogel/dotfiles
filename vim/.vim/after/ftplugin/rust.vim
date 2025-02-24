vim9script

compiler cargo
# setlocal makeprg=cargo\ --quiet\ rustc\ --message-format=short\ $*\ --\ -Awarnings
# setlocal makeprg=cargo\ --quiet\ build\ --message-format=short
# src/ui/task_list.rs:85:33: error[E0599]: the method `add` exists for reference `&ListBox`, but its trait bounds were not satisfied
setlocal errorformat^=%f:%l:%c:\ error\[%s\]:\ %m,error:\ %s

# The vim-lsc and vim-rust plugins trash completeopt so reset it to my liking:
setlocal completeopt=menuone,popup

