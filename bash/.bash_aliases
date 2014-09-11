alias flexbuild='/usr/lib/jvm/java-6-sun/bin/java -jar "$FLEX_SDK_HOME/lib/mxmlc.jar" +flexlib="$FLEX_SDK_HOME/frameworks" -default-background-color=0xFFFFFF "$@"'
alias mgmtcmds='find . -type f -wholename "***/management/commands/*.py" | sed -r -e "/__init__.py/d" -e "s/(.*\/([^ /]+).py)/\2 \1/" | column -t'
alias tolowercase='tr "[A-Z]" "[a-z]"'
alias touppercase='tr "[a-z]" "[A-Z]"'
alias ffdev='firefox -no-remote -profile /home/dvogel/.mozilla/firefox/enw0f079.dev -purgecaches -jsconsole &'
alias gipython='python -m gevent.monkey $(which ipython)'
alias reload_history='history -a && history -n'

alias githist='git log --graph --branches --oneline'
alias gst='git status'
alias glog='git log'
alias gsh='git show'
alias gdif='git diff'
alias gpl='git pull'
alias gcmt='git commit'

alias bex='bundle exec'
alias binst='bundle install'

[[ -e /usr/local/bin/ctags ]] && alias ctags=/usr/local/bin/ctags

[[ -e ~/.bash_aliases.local ]] && source ~/.bash_aliases.local

