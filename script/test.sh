#!/bin/bash

gScriptName=$(basename $0)
gScriptPWD=$(dirname $(realpath $0))

echo "gScriptName=$gScriptName, gScriptPWD=$gScriptPWD"
source $gScriptPWD/shell_log.sh

DEBUG "debug msg"
INFO "info msg"
WARN "warn msg"
ERROR "error msg"
