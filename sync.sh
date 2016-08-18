#!/bin/bash

catch_int () 
{
   echo "you press ctrl+c,quit loop" 
   loop=0
}

do_work()
{
    while [ $loop != 0 ]
    do
        let "ttl_cnt+=1"
        
        cmd_start=`cat /proc/uptime |cut -d " " -f 1`
        #repo sync 
        psa
        if [ $? == 0 ];then
            loop=0
            echo "sync succussful"
        else
            echo "======================sync fail======================="
            let "fail_cnt+=1"

        fi
        cmd_end=`cat /proc/uptime |cut -d " " -f 1`
        #t= echo "$cmd_end-$cmd_start" > bc
        echo "total times=" $ttl_cnt
        echo "fail times=" $fail_cnt
        #echo "spend time:" $t 
    done

    time_end=`cat /proc/uptime |cut -d " " -f 1`
    #t= echo "$cmd_end-$cmd_start" > bc
    #echo -n "total execute time:" 
    #echo $t
}

function sync_android()
{
    loop=1 # loop flag, 1:loop, 0:quit
    ttl_cnt=0
    fail_cnt=0

    time_start=`cat /proc/uptime |cut -d " " -f 1`

    trap "catch_int" SIGINT
    
    do_work
}

sync_android
