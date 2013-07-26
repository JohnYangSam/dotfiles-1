# Upthere Android Env Setup #
upthere_src=/Users/jmow/Code/upthere
scripts=/Users/jmow/Code/dotfiles/scripts

export ANDROID_SDK_HOME=/Users/jmow/Code/android_tools_macosx_r8e/android-sdk-macosx
export ANDROID_NDK_HOME=/Users/jmow/Code/android_tools_macosx_r8e/android-ndk-r8e
export NDK_BASE=$ANDROID_NDK_HOME
ulimit -n 10000
fits() {
	cd $upthere_src
	./bin/rest_bridge
}
localfits() {
	cd $upthere_src
	./bin/rest_bridge --local_fits=true
}
upthere() {
	launchctl unload ~/Library/LaunchAgents/com.upthere.rest_bridge.plist
	launchctl load ~/Library/LaunchAgents/com.upthere.rest_bridge.plist
}
fuse() {
	/Users/jmow/upfs --username=jmow@upthere.com ~upthere /Users/jmow/updrive
	/Users/jmow/upfs --username=jmow@upthere.com Skyline /Users/jmow/skyline
}

logcat() {
	cd $scripts
	./colored_logcat.py $@
}

# FILE JUMPS #
alias home='j ~/'
alias cis121='j ~/School/cis121/12fa/'
alias school='j ~/School/'

alias ..='j ..'
alias ...='j ../../'
alias ....='j ../../../'
alias .....='j ../../../../'
alias ......='j ../../../../../'

# BASH COMMANDS #
alias topcmds='cat ~/.bash_history | sed "s|sudo ||g" | cut -d " " -f 1 | sort | uniq -c | sort -n'
alias mkdir='mkdir -pv'
alias l='ls -alh'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias less='less -F'
alias t='date -u "+%Y-%m-%dT%H:%M:%S"'
export histchars="!?#"

# GIT ALII #
alias st='git status'
alias log='git log'
alias gitsearch='git rev-list --all | xargs git grep -F'
alias stash='git stash'
alias pull='git pull --rebase'
alias push='git push'

alias co='git checkout'
alias cherry='git cherry-pick'
alias ca='git commit -am'
alias cm='git commit -m'
alias br='git branch'

# Git Assume/Unassume unchanged #
alias assume='git update-index --assume-unchanged'
alias unassume='git update-index --no-assume-unchanged'
alias assumed='git ls-files -v | grep ^h | cut -c 3-'

# Python Utils #
alias python27='python'
alias pyclean='rm -f *pyc'
alias py='env/bin/python'
alias json="python -mjson.tool"

md() {
	python -m markdown $1 > markdown.html
	open markdown.html
}

# COLORS #
export CLICOLOR=1
export LSCOLORS=BxHxFxDxCxegedabagacad
export EDITOR=vi

# FILE SYSTEM SEARCH AND JUMP #
bashconfig() {
    vi ~/.bash_profile
    source ~/.bash_profile
}

fs() {
    find . -type f -exec grep -nH -e $1 {} +
}

j() {
    $(jump.py $@) && pwd && ls
}

slime() {
    open -a "Sublime Text 2" $1 || (touch $1; open -a "Sublime Text 2" $1)
}

# extract archives #
extract() {
    
    if [ -f $1 ] ; then
        case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x $1       ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *)           echo "don't know how to extract '$1'..." ;;
      esac
  else
      echo "'$1' is not a valid file!"
  fi
}

# Print External IP Address #
ip() {
  local interface=""
  local types='vmnet|en|eth|vboxnet'
  local i
  for i in $(
    ifconfig \
    | egrep -o '(^('$types')[0-9]|inet (addr:)?([0-9]+\.){3}[0-9]+)' \
    | egrep -o '(^('$types')[0-9]|([0-9]+\.){3}[0-9]+)' \
    | grep -v 127.0.0.1
  ); do
    if ! [ "$( echo $i | perl -pi -e 's/([0-9]+\.){3}[0-9]+//g' )" == "" ]; then
      interface="$i":
    else
      echo $interface $i
    fi
  done
}

# Print MAC Addresses #
mac() {
  local interface=""
  local i
  local types='vmnet|en|eth|vboxnet'
  for i in $(
    ifconfig \
    | egrep -o '(^('$types')[0-9]:|ether ([0-9a-f]{2}:){5}[0-9a-f]{2})' \
    | egrep -o '(^('$types')[0-9]:|([0-9a-f]{2}:){5}[0-9a-f]{2})'
  ); do
    if [ ${i:(${#i}-1)} == ":" ]; then
      interface=$i
    else
      echo $interface $i
  fi
  done
}

xpdf()
{
    xelatex $1.tex;
    open $1.pdf
}

pdf()
{
    pdflatex $1.tex;
    open $1.pdf
}

# Start an HTTP server from a directory, optionally specifying the port
function server() {
    # Default to port 8000
    local port="${1:-8000}"
 
    # Since the one-liner blocks, we open the browser beforehand. However, we want to
    # wait just a couple of seconds since the server will not be ready just yet.
    # Also, I think Linux users should be able to use 'xdg-open' ('open' is for OS X).
    # ( sleep 2; open "http://localhost:${port}/" ) &
 
    python -m SimpleHTTPServer "$port"
}

export PATH=/usr/local/bin:/Users/jmow/Code/dotfiles/scripts:/Users/jmow/Code/android_tools_macosx_r8e/android-ndk-r8e:/Users/jmow/Code/android_tools_macosx_r8e/android-sdk-macosx/platform-tools:/Users/jmow/Code/android_tools_macosx_r8e/android-sdk-macosx/tools:"$PATH"
export ANDROID_HOME=/Users/jmow/Code/android_tools_macosx_r8e/android-ndk-r8e

set -o vi
alias :q='clear'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
