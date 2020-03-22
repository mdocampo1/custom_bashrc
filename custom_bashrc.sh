#! /bin/bash

######################################################
# VARIABLES
######################################################
# Home directory upon opening a shell
DIR_HOME=/home/${USERNAME}/

# Remote directory used for mounts (VMs)
DIR_MOUNT=/mnt/hgfs/

# Enables (1) and disables (0) debug logging
DBG=0

# Path for git master branch (if not 'master' as default)
GMASTER=HEADS:refs/for/master

######################################################
# ALIASES
######################################################
alias xremote="xcd ${DIR_MOUNT}"
alias xhome="xcd ${DIR_HOME}"

alias xls="clear && ls -lrtA"
alias dirSize="du -sh"
alias compress="tar -czvf"

# git aliases
# https://stackoverflow.com/questions/35979642/what-is-git-tag-how-to-create-tags-how-to-checkout-git-remote-tags
alias fetchTags="git fetch --all --tags --prune"
alias gpull="git pull && git submodule update --init --recursive"

######################################################
# FUNCTIONS
######################################################
function xcd() {
  if [ $# -gt 1 ]; then
    echo "Usage: xcd <path>"
  else
    cd $1
    xls
  fi
}

function xdbgEcho() {
  if [ $# -ne 0 ]; then
    if [ $DBG -eq 1 ]; then
      echo "[DBG]" $*
    fi
  fi
}

# https://github.com/xvoland/Extract/blob/master/extract.sh
function extract {
  if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
  else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
  fi
}

function gpush()
{
  case $# in
    0) git push origin master
    ;;
    1) git push origin $1
    ;;
    *) echo "Usage: gpush <repository>"
    ;;
  esac
}

######################################################
# DEFAULT CALLS
######################################################
xhome


