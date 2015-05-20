#!/bin/bash
#changlist
#1. add regular expression(use 'ls -d dirname') for exclude file/dir

fn="_exclude_tmp_file"
ex_options=""

#add the file/directory you want to exclude
#each file/dir per line
#files
exclude_file=(

)

#directory
exclude_dir=(
#not arch/mips/
"arch/[^m]*/"

#not arch/mips/xburst/soc-m200/
"arch/mips/xburst/soc-[^m]*/"

#not arch/mips/xburst/soc-m200/board/newton/
"arch/mips/xburst/soc-m200/board/[^n]*/"

)

function process_ex_file()
{
    for val in ${exclude_file[@]}
    do
        if [ $val ];then
            #echo $val
            echo $val >> $fn
        fi
    done
}

function process_ex_dir()
{
    for val in ${exclude_dir[@]}
    do
        if [ $val ];then
            #echo $val
            ls -d $val >> $fn
        fi
    done
}

function generate_result()
{
    while read eachline
    do
        if [ $eachline ];then
            if [ -d $eachline ];then
                ex_options+=" --exclude=${eachline}*"
            elif [ -f $eachline ];then
                ex_options+=" --exclude=${eachline}"
            fi
            #echo ${ex_options}, $eachline
        fi
    done < $fn
    #echo ${ex_options}
}

# execute from here
if [ -f $fn ];then
    rm $fn
    echo "remove $fn"
fi

process_ex_file
process_ex_dir
generate_result

if [ -f "tags" ];then
    rm -rf tags
fi

ctags -R $ex_options
ls -lh tags

#rm $fn
