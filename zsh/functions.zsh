################################################################
########################DUFFERNAMA##############################
################################################################
# Google stuff from the command-line
google() {
    search=""
    echo "Googling: $@"
    for term in "$@"; do
        search="$search%20$term"
    done
    xdg-open "http://www.google.com/search?q=$search"
}

# Explain a shell command and it's params
# https://www.mankier.com/blog/explaining-shell-commands-in-the-shell.html
explain () {
  if [ "$#" -eq 0 ]; then
    while read  -p "Command: " cmd; do
      curl -Gs "https://www.mankier.com/api/explain/?cols="75 --data-urlencode "q=$cmd"
    done
    echo "Bye!"
  elif [ "$#" -eq 1 ]; then
    curl -Gs "https://www.mankier.com/api/explain/?cols="75 --data-urlencode "q=$1"
  else
    echo "Usage"
    echo "explain                  interactive mode."
    echo "explain 'cmd -o | ...'   one quoted command to explain it."
  fi
}

# File extractor
# usage: extract <file>
extract ()
{
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *.snz)       snunzip "$1"      ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Bind quick stuff to enter!
#
# Pressing enter in a git directory runs `git status`
# in other directories `ls`
magic-enter () {
  if [[ -z $BUFFER ]]; then
    echo ""
    if git rev-parse --is-inside-work-tree &>/dev/null; then
      git status -u .
    else
      ls -CF
    fi
    zle redisplay
  else
    zle accept-line
  fi
}
zle -N magic-enter
bindkey "^M" magic-enter

# Open the current folder in user's preferred
# file browser
# Todo: Find a way of focussing the browser too!
ctrl-enter () {
  if [[ -z $BUFFER ]]; then
    xdg-open .
  else
    xdg-open "$BUFFER"
    zle redisplay
  fi
}
zle -N ctrl-enter
bindkey "^J" ctrl-enter