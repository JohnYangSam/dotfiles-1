# Upthere #
upfuse() {
    /Users/JMow/Code/upthere/upfs --username=jmow@upthere.com Skyline /Users/JMow/Code/upthere/skyline
    /Users/JMow/Code/upthere/upfs --username=jmow@upthere.com ~upthere /Users/JMow/Code/upthere/updrive
}

fits() {
    cd /Users/JMow/Code/upthere/upthere;
    ./bin/rest_bridge
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

lr() {
    ls -R . | awk '
    /:$/&&f{s=$0;f=0}
    /:$/&&!f{sub(/:$/,"");s=$0;f=1;next}
    NF&&f{ print s"/"$0 }'
}

# GIT ALII #
alias st='git status'
alias log='git log'
alias gs='git rev-list --all | xargs git grep -F'
alias stash='git stash'
alias fetch='git fetch --all'
alias pull='git pull --rebase'
alias push='git push'
alias br='git branch'

alias co='git checkout'
alias cherry='git cherry-pick'
alias ca='git commit -am'
alias cm='git commit -m'
alias amend='git commit --amend'

source ~/.git-completion.bash

# Git Assume/Unassume unchanged #
alias assume='git update-index --assume-unchanged'
alias unassume='git update-index --no-assume-unchanged'
alias assumed='git ls-files -v | grep ^h | cut -c 3-'

# Python Utils #
alias python27='python'
alias pyclean='rm -f *pyc'
alias py='env/bin/python'
alias env='source env/bin/activate'
alias json="python -mjson.tool"

md() {
       python -m markdown $1 > markdown.html
       open markdown.html
}

# COLORS #
export CLICOLOR=1
export LSCOLORS=BxHxFxDxCxegedabagacad
export EDITOR=vi

# EC2 SSH/SCP IDENTITY #
sshp() {
    #ssh -i ~/.ec2/pokedex.pem ec2-user@pokedex.me
    #ssh -i ~/.ec2/login.pem ec2-user@ec2-107-22-46-87.compute-1.amazonaws.com
    #ssh -i ~/.ec2/cis555.pem ubuntu@ec2-75-101-168-199.compute-1.amazonaws.com
    ssh -i ~/.ec2/cis555.pem ubuntu@54.235.148.12
}

sshb() {
    ssh -i ~/.ec2/cis555.pem ec2-user@ec2-54-224-186-71.compute-1.amazonaws.com
}

sshu() {
    #ssh -i ~/.ec2/login.pem ubuntu@$1
    ssh -i ~/.ec2/login.pem ubuntu@ec2-107-22-127-103.compute-1.amazonaws.com
}

sshi() {
    ssh -i ~/.ec2/login.pem ec2-user@$1
    #ssh -i ~/.ec2/cis555.pem ec2-user@$1
}

scpi-down() {
    scp -i ~/.ec2/login.pem ec2-user@$1:$2 .
}

scpi-up() {
    scp -i ~/.ec2/login.pem $2 ec2-user@$1:
}

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

cv()
{
    git checkout master;
    xelatex cv.tex;
    mv cv.pdf jasonmow.resume.2013.pdf;
    git checkout personal;
    xelatex cv.tex;
    mv cv.pdf jasonmow.personal.resume.2013.pdf;
    git checkout master
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

ssheniac()
{
	ssh jmow@minus.seas.upenn.edu
}

ssh121()
{
	ssh cis121@minus.seas.upenn.edu
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

sshtcr()
{
	ssh thecampusrep@thecampusrep.webfactional.com
}

sshlinode()
{
    ssh jmow@198.74.57.12
}

sshlinoderoot()
{
    ssh root@198.74.57.12
}

# Usage: seasprint foo.pdf
function seasprint() {
   cat "$1" | ssh jmow@minus.seas.upenn.edu lpr -P169
}

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# export ANDROID_HOME="/Applications/eclipse/android-sdk-macosx"
export ANDROID_HOME="/Users/JMow/android-sdks"
export PATH="$PATH":/Users/JMow/Code/scripts:/Users/JMow/pebble-dev/arm-cs-tools/bin:$ANDROID_HOME/platform-tools

export PYTHONSTARTUP=/Users/JMow/.pythonrc
export EC2_PRIVATE_KEY=/Users/JMow/.ec2/access.pem
export EC2_CERT=/Users/JMow/.ec2/cert.pem

fortune -s -a | cowthink -f dragon-and-cow | lolcat
# fortune | cowsay -s | lolcat

set -o vi
alias :q='clear'
