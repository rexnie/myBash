#!/bin/bash
#this tool will create a tag file for ctag command
#with exclude file/diretory,which u can config it
#the basic idea is: ctag -R --exclude=xxxx

#add the file/directory you want to exclude
#each file/dir per line
#dir comes behind the file item
exclude_f=( 
#files

# directory
"arch/alpha/*"
"arch/arm/*"
"arch/iavr32/*"
"arch/blackfin/*"
"arch/cris/*"
"arch/frv/*"
"arch/h8300/*"
"arch/ia64/*"
"arch/m32r/*"
"arch/m68k/*"
"arch/microblaze/*"
"arch/mn10300/*"
"arch/parisc/*"
"arch/score/*"
"arch/sh/*"
"arch/sparc/*"
"arch/tile/*"
"arch/um/*"
"arch/unicore32/*"
"arch/x86/*"
"arch/xtensa/*"

"arch/mips/xburst/soc-4775/board/inwatch2"
"arch/mips/xburst/soc-4775/board/m16"
"arch/mips/xburst/soc-4775/board/orion"
"arch/mips/xburst/soc-4775/board/s2*/*"
"arch/mips/xburst/soc-4775/board/sw501"
"arch/mips/xburst/soc-4775/board/test"

)

array_len=${#exclude_f[@]}
options=""

for((i=0;i<array_len;i++))
do
    #echo $i,${exclude_f[$i]}
    options+="--exclude=${exclude_f[$i]} "
done

#echo $options
if [ -f "tags" ];then
    rm -rf tags
fi

ctags -R $options
ls -lh tags
