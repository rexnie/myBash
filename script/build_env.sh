#!/bin/bash -
#===============================================================================
#
#          FILE: build_env.sh
#
#         USAGE: ./build_env.sh
#
#   DESCRIPTION: 
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

SW_REPO=/repo/`whoami`/ms/sw
BR_REPO=/repo/`whoami`/buildroot

# build_me def config
HOST_IP=$(hostname -I | awk '{print $1}')
BR_REPO_PREFIX=ssh://buildmgr@$HOST_IP
BR_REV=""
OUTPUT_PATH=/repo/`whoami`/buildme
LIMITED_BUILDS=""
PACKAGE="n"
NO_SST_UT_CPPCHK="n"

# SB config
SUPERBATCH="n"
SB_ITEMS=$HOME/superbatch_items.txt

# local_build def config
BOARD="cfnt-b"
BR_CUSTOME=0
BR_DIR=""


get_build_id()
{
    if [ ! -f $HOME/.build_id ]; then
        echo 826 > $HOME/.build_id
    fi

    build_id=$(cat $HOME/.build_id)
    build_id=$(($build_id + 1))
    if [[ $build_id > 829 ]]; then
        build_id=826
    fi

    echo $build_id > $HOME/.build_id
    echo $build_id
}



check_buildme_env ()
{
    if [ ! -d $SW_REPO ]; then
        ERROR "$SW_REPO doesn't exist!"
        exit 1
    fi

    if [ -z $SW_REV ]; then
        ERROR "you must define SW_REV"
        exit 1
    fi

    if [ ! -d $OUTPUT_PATH ]; then
        ERROR "$OUTPUT_PATH doesn't exist!"
    fi

    if [[ $BR_REPO != "" && ! -d $BR_REPO ]]; then
        ERROR "$BR_REPO doesn't exist!"
        exit 1
    fi

    if [[ $BR_REPO != "" && -z $BR_REV ]]; then
        ERROR "you define BR_REPO, must define BR_REV"
        exit 1
    fi

}	# ----------  end of function check  ----------

# only support buildme local sw repo
# $1: y:do realy build, n: not build, just check parameter
build_me ()
{
    local do_build=$1
    local cmd=""

    if [ $(hostname) == FNSHA190 ] ; then
        WARN "DO NOT run on FNSHA190"
    fi

    if ! check_buildme_env; then
        ERROR "check_buildme_env fail, exit"
        exit 1
    fi

    build_id=$(get_build_id)

    cd $SW_REPO

    if [[ $BR_REPO != "" ]]; then
        #cmd="buildme --repo $BR_REPO_PREFIX/$BR_REPO --rev $BR_REV"
        cmd="buildme --repo $BR_REPO --rev $BR_REV"
        cmd="$cmd --build_id $build_id --wait --backup &&"
    fi

    cmd="$cmd buildme --repo $SW_REPO --rev $SW_REV"

    if [[ $PACKAGE == "y" ]]; then
        cmd="$cmd --package_directory $OUTPUT_PATH"
    fi

    cmd="$cmd --build_id $build_id"

    if [[ $NO_SST_UT_CPPCHK == "y" ]]; then
        cmd="$cmd --no-sst --no-unittest --no-cppcheck"
    fi

    if [[ $LIMITED_BUILDS != "" ]]; then
        cmd="$cmd --limited_builds \"$LIMITED_BUILDS\""
    fi

    if [[ $SUPERBATCH == "y" ]]; then
        cmd="$cmd --superbatch --superbatch_file $SB_ITEMS"
    fi

    INFO "cmd="$cmd


    if [[ $do_build == "y" ]]; then
        echo -e "\n\n-----------------`date`--------------" >>$gScriptPWD/cmd_buildme.log
        echo $cmd >>$gScriptPWD/cmd_buildme.log

        echo "SW_REPO="$SW_REPO >>$gScriptPWD/cmd_buildme.log
        echo "SW_REV="$SW_REV >>$gScriptPWD/cmd_buildme.log
        echo "BR_REPO="$BR_REPO >>$gScriptPWD/cmd_buildme.log
        echo "BR_REV="$BR_REV >>$gScriptPWD/cmd_buildme.log
        echo "LIMITED_BUILDS="$LIMITED_BUILDS >>$gScriptPWD/cmd_buildme.log
        echo "PACKAGE="$PACKAGE >>$gScriptPWD/cmd_buildme.log
        echo "OUTPUT_PATH="$OUTPUT_PATH >>$gScriptPWD/cmd_buildme.log

        INFO "do realy build now"
        eval $cmd
    else
        INFO "not build, just check parameter, done"
    fi
}	# ----------  end of function buildme  ----------


check_local_build_env()
{
    if [ ! -d $SW_REPO ]; then
        ERROR "$SW_REPO doesn't exist!"
        exit 1
    fi

    if [ -z $BOARD ]; then
        ERROR "you must define BOARD you want to build"
        exit 1
    fi

    if [ ! -d $OS_PATH ]; then
        ERROR "$OS_PATH doesn't exist!, SW_REPO=$SW_REPO, BOARD=$BOARD"
        exit 1
    fi

    if [[ $BR_DIR == "" ]]; then
        ERROR "BR_DIR is null, pls define BOARD or BR_REPO"
        exit 1
    fi

    if [ ! -d "$BR_DIR" ]; then
        ERROR "$BR_DIR doesn't exist!"
        exit 1
    fi
}

get_br_dir()
{
    if [ ! -z $BR_REPO ]; then #define BR_REPO
        echo $BR_REPO
    else
        local cpu=""
        local mboard=""
        local mid=vobs/esam/build/reborn/buildroot-isam-reborn

        case "$BOARD" in
            cfnt-b|cfnt-c)
                cpu=cavium
                mboard=cfntb
                ;;

            fant-g)
                cpu=ppc
                mboard=fantg
                ;;
            fglt-b|fglt-c|fwlt-a|fwlt-b|fylt-p|felt-b|cwlt-a|felt-c|fnio-d)
                cpu=cavium
                mboard=fgltb
                ;;
            *)
                ERROR "board error: " $BOARD
                exit 1
                ;;
        esac
        echo $SW_REPO/$mid-$cpu-$mboard
    fi
}


local_build ()
{
    local br_dir=""
    OS_PATH=$SW_REPO/build/$BOARD/OS
    BR_DIR=$(get_br_dir)
    DEBUG "BR_DIR=" $BR_DIR

    if ! check_local_build_env; then
        ERROR "check_local_build_env fail, exit"
        exit 1
    fi

    _FNUM=`cat ~/vers`

    local cmd="cd $OS_PATH && \
        hmake $* -j20 \
        VERS=$_FNUM"

    if [[ $BR_REPO != "" ]]; then
        cmd="$cmd BUILDROOT=$BR_REPO"
    fi

    if [ $BR_CUSTOME -eq 1 ]; then
        cmd="$cmd BUILDROOT_CUSTOME=1"
    fi

    cmd="$cmd 2>&1 | tee $gScriptPWD/local_build.log"

    INFO "cmd="$cmd
    INFO "BR_DIR= "$BR_DIR

    echo -e "\n\n-----------------`date`--------------" >>$gScriptPWD/cmd_local_build.log
    echo $cmd >>$gScriptPWD/cmd_local_build.log
    echo "SW_REPO="$SW_REPO >>$gScriptPWD/cmd_local_build.log
    echo "BR_REPO="$BR_REPO >>$gScriptPWD/cmd_local_build.log
    echo "OS_PATH="$OS_PATH >>$gScriptPWD/cmd_local_build.log
    echo "BR_DIR="$BR_DIR >>$gScriptPWD/cmd_local_build.log
    echo "BUILDROOT_CUSTOME="$BR_CUSTOME >>$gScriptPWD/cmd_local_build.log

    eval $cmd
 
}	# ----------  end of function local_build  ----------


