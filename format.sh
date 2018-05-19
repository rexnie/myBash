#! /bin/bash

fn=""
# --suffix=none 不保存原始文件
# -p 在()两边插入空格
# --recursive 递归处理子目录
options="--style=kr --suffix=none -p"

echox()
{
    echo -e "\e[0;91m$1\e[0m"
}

usage()
{
    echo "Usage:"
    echo -e "\tformat.sh a.xx\t\tformat specific file"
    echo -e "\tformat.sh *.xx\t\tformat all *.xx under ./ "
    echo -e "\tformat.sh path/*.xx\tformat all .xx under path"
    echo -e "\tformat.sh path\t\tformat *.h *.c *.cpp under path"
    echo -e "\t\t\t\txx can be c/cpp/h/java/...\n"
}

if [ $# -ne 1 ]; then
    echox "paraments should be 1"
    usage
    exit 1
fi

result=$(echo $1 | grep "*")
if [ -f $1 ]; then
    fn=$1
elif [[ $result != "" ]]; then
    fn=$1
    options="$options --recursive"
else
    fn="$1/*.h $1/*.c $1/*.cpp"
    options="$options --recursive"
fi

astyle ${options} $fn
echox "Done...astyle return $?"
