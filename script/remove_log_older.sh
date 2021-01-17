#!/bin/sh
# move last_modify_time > 3*24h to tmp/
# dir structure:
# logs
# ..backup
# ....clean.sh
# ..tmp
# 
cd ..
# for test, not mv actually
#find . -maxdepth 1 -mtime +3 -type f -name "*.log" -exec ls {} \;
find . -maxdepth 1 -mtime +3 -type f -name "*.log" -exec mv -f {} tmp/ \;
echo "Done."
cd - 2> /dev/null

