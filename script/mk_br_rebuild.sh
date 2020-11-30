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

# redownload & full rebuild
#make $pkg-dirclean
#make $pkg-rebuild 2>&1|tee $LOGFILE

# change code under output/build/xxxx/, rebuild
make $pkg-reconfigure 2>&1|tee $LOGFILE

date >> $LOGFILE

