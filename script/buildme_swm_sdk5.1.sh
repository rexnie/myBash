#!/bin/bash -
#===============================================================================
#
#          FILE: buildme_fanth.sh
#
#         USAGE: ./buildme_fanth.sh
#
#   DESCRIPTION: check dependency of target board under sw/packaging/board_info/pack_$BOARD.yaml,
# if it include other package, add it to LIMITED_BUILDS
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Wu Xufeng (), Xufeng.Wu@alcatel-sbell.com.cn
#  ORGANIZATION: 
#       CREATED: 04/27/2018 02:41:21 PM
#      REVISION:  ---
#===============================================================================

set -o nounset                                  # Treat unset variables as an error


gScriptName=$(basename $0)

gScriptPWD=`pwd`
source $HOME/script/shellLog.sh > /dev/null
source $HOME/script/build_env.sh > /dev/null

# override parameter define in build_env.sh
#SW_REPO=/repo/`whoami`/ms_lmnt-a/sw
SW_REPO=/repo/`whoami`/ms_lmnta/sw
SW_REV=a308f4130cdb

#BR_REPO=/repo/`whoami`/buildroot_cmt
BR_REPO=""
#BR_REV=dcf53d092159
LIMITED_BUILDS="fglt-b fwlt-b common lscx-a sdmv-a cfnt-b"
#LIMITED_BUILDS="common fant-f fant-g fant-h nvps-c fglt-b fglt-c felt-b cfnt-b fwlt-b fnio-d cfnt-c felt-c cfnt-d sdmv-a fvnt-a lsfx-a lscx-a"
#LIMITED_BUILDS="complete -target=-ut" # for SB
PACKAGE="y"
SUPERBATCH="n"

build_me y

