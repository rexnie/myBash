#!/bin/bash

CHOOSE=-1

echox()
{
  echo -e "\e[0;91m$1\e[0m"
}

usage_()
{
    echox "select java:\n"
    echo "1. use JDK 1.6"
    echo "2. use openJDK 1.7"
    echo "3. use JDK 1.7"
}

read_input()
{
    usage_
    read -p "Enter here: " CHOOSE
}
do_choose()
{
    if [ ${CHOOSE} -eq 1 ];then
        echo "1" | sudo -S -s update-alternatives --set java /home/niedaocai/tools/jdk1.6.0_30/bin/java
        echo "1" | sudo -S -s update-alternatives --set javac /home/niedaocai/tools/jdk1.6.0_30/bin/javac
        echo "1" | sudo -S -s update-alternatives --set javadoc /home/niedaocai/tools/jdk1.6.0_30/bin/javadoc
    elif [ ${CHOOSE} -eq 2 ];then
        echo "1" | sudo -S -s update-alternatives --set java /usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java
        echo "1" | sudo -S -s update-alternatives --set javac /usr/lib/jvm/java-7-openjdk-amd64/bin/javac
        echo "1" | sudo -S -s update-alternatives --set javadoc /usr/lib/jvm/java-7-openjdk-amd64/bin/javadoc
    elif [ ${CHOOSE} -eq 3 ];then
        echo "1" | sudo -S -s update-alternatives --set java /home/niedaocai/tools/jdk1.7.0_51/bin/java
        echo "1" | sudo -S -s update-alternatives --set javac /home/niedaocai/tools/jdk1.7.0_51/bin/javac
        echo "1" | sudo -S -s update-alternatives --set javadoc /home/niedaocai/tools/jdk1.7.0_51/bin/javadoc
    else
        echox 'Input error'
    fi
}
read_input
do_choose
