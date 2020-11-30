#!/bin/bash

gScriptName=$(basename $0)
gScriptPWD=$(dirname $(realpath $0))

source $gScriptPWD/shell_log.sh

if [ $# -ne 1 ]; then
	ERROR "Usage: $0 pkg"
	exit 1
fi

pkg=$1
LOGFILE="$1_rebuild.log"
INFO "$1-rebuild starting..."

# use case 1: redownload & full rebuild
# code clean, long build time
# note: make $pkg-source do NOT sync code
#make $pkg-dirclean
#make $pkg-rebuild 2>&1|tee $LOGFILE

# use case 2: change code under output/build/xxxx/, rebuild
# modify under build dir, short build time
make $pkg-reconfigure 2>&1|tee $LOGFILE

date >> $LOGFILE

