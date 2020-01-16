alias ll='ls -ltr'
alias mgmtcmds='find . -type f -wholename "***/management/commands/*.py" | sed -r -e "/__init__.py/d" -e "s/(.*\/([^ /]+).py)/\2 \1/" | column -t'
alias tolowercase='tr "[A-Z]" "[a-z]"'
alias touppercase='tr "[a-z]" "[A-Z]"'
alias ffdev='firefox -no-remote -profile /home/dvogel/.mozilla/firefox/enw0f079.dev -purgecaches -jsconsole &'
alias gipython='python -m gevent.monkey $(which ipython)'
alias reload_history='history -a && history -n'
alias purge_vim_swap_files='find . -name ".*.swp" -print0 | xargs -0 -- rm'
alias va_mfa='source ~/p/devops/utilities/issue_mfa.sh Drew.Vogel'
alias xclipin='xclip -in -selection secondary'
alias urldecode='python -c "import sys, urllib as ul; enc=sys.stdin.read(); print ul.unquote_plus(enc)"'

alias githist='git log --graph --branches --oneline'
alias gst='git status'
alias glog='git log'; __git_complete glog _git_log
alias gsh='git show'
alias gdif='git diff'
alias gpl='git pull'
alias gcmt='git commit'
alias gsu='git submodule update'
alias gsubs='git submodule init && git submodule sync && git submodule update'
alias gco='git checkout'; __git_complete gco _git_checkout
alias gmaster='git checkout master'
alias gchanges='git whatchanged HEAD^.. | cat'
alias ffmerge='git merge --ff-only'
alias shaof='git rev-parse'
alias lastcommit='git log HEAD^.. | cat'


alias bex='bundle exec'
alias binst='bundle install'
alias locked_revisions="cat Gemfile.lock | egrep '^(GIT|\s+remote:|\s+revision:)'"

[[ -e /usr/local/bin/ctags ]] && alias ctags=/usr/local/bin/ctags

[[ -e ~/.bash_aliases.local ]] && source ~/.bash_aliases.local

