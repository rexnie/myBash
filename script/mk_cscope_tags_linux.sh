#!/bin/sh
# create cross-reference file for cscope and ctags, this will only index specific arch
# put me to your PATH env, then
# cd root_of_linux_source_code
make ARCH=arm64 cscope tags
