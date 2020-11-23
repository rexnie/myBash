#!/bin/bash

#
# http://astyle.sourceforge.net/astyle.html
#

options="--style=kr \
    --indent=spaces=4 \
    --align-pointer=name \
    --max-code-length=200 \
    --break-after-logical \
    --pad-oper \
    --pad-header \
    --unpad-paren"

single_fn=$1
if [ -f "$single_fn" ]; then
    astyle $options "$single_fn"
    exit 0
fi

# file extension
#for f in $(find $(realpath $1) -name "*.[hc]" | xargs) # *.c *.h
for f in $(find $(realpath $1) -regex ".*\.hpp\|.*\.cpp\|.*\.c\|.*\.h" | xargs) # *.hpp *.cpp *.c *.h
do
    astyle $options $f
done

echo $options
