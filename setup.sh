#!/bin/sh
set -eu
cd "`dirname "\`readlink -f "$0"\`"`"


#############################
##      set variables      ##
#############################

. ./lib/utils.sh
. ./lib/var.sh
. ./lib/func.sh


#############################
##      read options       ##
#############################

if [ $# -eq 0 ]; then
  usage
  exit 0
else
  case "$1" in
    help | --help | -h )
      usage
      exit 0
      ;;
    install   | --install   | i | -i )
      mode=install
      shift
      ;;
    uninstall | --uninstall | u | -u )
      mode=uninstall
      shift
      ;;
    check     | --check     | c | -c )
      mode=check
      shift
      ;;
    * )
      info "read_option"
      error "invalid argument \"$1\""
      exit 1
      ;;
  esac
fi


#############################
##   read command option   ##
#############################

while [ $# -gt 0 ]; do
  opt="`echo $1`"
  if [ ${#opt} -ne 0 ]; then
    case "$opt" in
      --help | -h )
        usage "$mode"
        exit 0
        ;;
      --force | -f )
        opt_force=true
        ;;
      "--target="* )
        opt2="${opt#"--target="}"
        if [ ${#opt2} -ne 0 ]; then
          if [ ! -d "$opt2" ]; then
            error "\"$opt2\" is not dir."
            exit 13
          else
            TARGET_DIR="$opt2"
          fi
        else
          error "invalid arguments"
          exit 12
        fi
        ;;
      -t )
        if [ $# -gt 1 ]; then
          opt2="`echo "$2"`"
          if [ ${#opt2} -ne 0 ]; then
            if [ ! -d "$opt2" ]; then
              error "\"$opt2\" is not dir."
              exit 13
            else
              case "$opt" in
                -t )
                  TARGET_DIR="$opt2"
                  ;;
              esac
            fi
            shift
          else
            error "invalid arguments"
            exit 12
          fi
        else
          error "invalid arguments"
          exit 12
        fi
        ;;
      --* )
        info "$mode: read_option"
        error "invalid argument \"$opt\""
        exit 2
        ;;
      -* )
        _opt="`echo "$opt" | cut -c 2-`"
        for i in `seq ${#_opt}`; do
          o="`echo $_opt | cut -c $i`"
          case "$o" in
            h )
              usage "$mode"
              exit 0
              ;;
            f )
              opt_force=true
              ;;
            * )
              info "$mode: read_option"
              error "invalid argument \"$o\""
              exit 2
              ;;
          esac
        done
        ;;
      * )
        info "$mode: read_option"
        error "install: invalid argument \"$opt\""
        exit 2
        ;;
    esac
  fi
  shift
done


#############################
##     show information    ##
#############################

print_banner
yes = | head -n $COLUMNS | tr -d "\n" ; echo
info "Information"
echo "  $ESC[33muname$ESC[m: $ESC[90m\"$ESC[32m$OS$ESC[90m\"$ESC[m"
echo " $ESC[33mdistro$ESC[m: $ESC[90m\"$ESC[32m$DISTRO$ESC[90m\"$ESC[m"
echo " $ESC[33mtarget$ESC[m: $ESC[90m\"$ESC[32m$TARGET_DIR$ESC[90m\"$ESC[m"
echo "    $ESC[33mpwd$ESC[m: $ESC[90m\"$ESC[32m$DOTFILES_DIR$ESC[90m\"$ESC[m"
echo "   $ESC[33mmode$ESC[m: $ESC[90m\"$ESC[32m$mode$ESC[90m\"$ESC[m"
echo "  $ESC[33mforce$ESC[m: $ESC[90m\"$ESC[32m$opt_force$ESC[90m\"$ESC[m"
if [ "$OS" != "Linux" ]; then
  warn "Warning: \"$OS\" is not supported."
fi
if [ "$DISTRO" = "Unknown" ]; then
  warn "Warning: Distro is unknown."
fi
yes = | head -n $COLUMNS | tr -d "\n" ; echo


#############################
##           run           ##
#############################

printf "[y/n]: "
if [ "`get_key`" != "y" ]; then
  echo "NO"
  info "Canceled"
  exit 0
fi
echo "YES!"

for file in ./lists/*; do
  . "$file"
done
