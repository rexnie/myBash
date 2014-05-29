#!/bin/bash
#  This is the function list for studying shell program
#  new a function to do specific test case 
#  exit code 1 means error,0 means successful

#Key: test function statement
#$0 $1 $2 $@ $* $#
function first_func ()
{
    echo "print args:"
    echo -n '$0 $1 $2:  '
    echo $0,$1,$2

    echo -n '$#:  '
    echo $#
    
    echo -n '$@:  '
    echo $@
   
    echo -n '$*:  '
    echo $*
    
    exit 0
}

#Key: test `cmd` ,$(cmd)
create_new_file ()
{
    dt=`date +%Y%m%d`
    fn1="backup_$dt.txt"
    fn2="backup2_`date +%Y%m%d`.txt"
    echo -e "new file name is $fn1,\n$fn2"
    exit 0
}

#Key: test let,(()),expr
evaluate_expression ()
{
    declare -i x=3
    declare -i y=4
    let "z1=x*x+y*y"
    ((z2=x*x+y*y))

    # TODO: syntax error
    #z3=`expr $x * $x + $y * $y`
    echo "result is:$z1,$z2,$z3"
    exit 0
}

#Key: test if/test statement
test_example ()
{
    fn="/home/rex/work/myBash/functions.sh"
    #test -e "/home/rex" && echo "exists" || echo "Not exist"
    
    [ ! -e "$fn" ] && echo "not exist" && exit 1
    
    if [ -f "$fn" ];then
        echo "is a regular file" 
    elif [ -d "$fn" ];then
        echo "is a directory"
    else
        echo "it is other file"
    fi

    echo "file's perms is `ls -l $fn | cut -b 1-10`"
    exit 0 
}

#Key: test while/case statement 
create_menu ()
{
    declare -r menu="\n
      \tcommand menu\n
      d. crrent date and time\n
      w. users currently logged in\n
      n. name of pwd\n
      l. list of dir\n
      p. print menu\n
      q. quit\n\n
      enter your choice: d/w/n/l/p/q.
    "
    declare -i loop_flag=1
    
    echo -e $menu
    while [ "$loop_flag" != 0 ]
    do
        read -p "input your choice:" choice
        case "$choice" in 
            d | D)
                date
                ;;
            w | W)
                who
                ;;
            n | N)
                pwd
                ;;
            l | L)
                ls -l
                ;;
            p | P)
                echo -e $menu
                ;;
            q | Q)
                loop_flag=0
                ;;
            *)
                echo "input error",$choice
                echo -e $menu
                ;;
         esac       
    done    

    exit 0
}

#Key: test for statement
list_users ()
{
    users=`cut -d ':' -f1 /etc/passwd`
    
    for username in "$users"
    do
        id $username
        finger $username
    done
}

#Key: test for statement
ping_ip_group ()
{
    network="192.168.1"
    echo "host is up between 192.168.1.1 and 192.168.1.100:" > active_host.txt
    
    for sub in `seq 1 100`
    do
        ping -c 1 -w 1 $network.$sub &>/dev/null && result=0 || result=1
        if [ "$result" == 0 ];then
            echo "$network.$sub" >> active_host.txt
        fi
    done    
}

#Key: test for statement
for_example ()
{
    sum=0
    #bosh for statement is OK
    #for (( i = 0;i <= 100; i++ ))
    for((i = 0;i<=100;i++))
    do
        let "sum+=i"
    done
    echo "sum=$sum"
}

#Key: test getop(1) statement from official sample code
getopt_example ()
{
    # usage in bash command line 
    # ./functions.sh -a par1 'another arg' --c-long 'wow!*\?' -cmore -b " very long "
    #Option a:-a
    #Option c:--c-long, no argument
    #Option c:-c, argument:more
    #Option b:-b,argument: very long 
    #Remaining arguments:
    #--> par1
    #--> another arg
    #--> wow!*\?
    
    #echo $@

    # Note that we use `"$@"' to let each command-line parameter expand to a   
    # separate word. The quotes around `$@' are essential!  
    # We need TEMP as the `eval set --' would nuke the return value of getopt.
    TEMP=`getopt -o ab:c:: --long a-long,b-long:,c-long::\
        -n "getopt_example" -- "$@"`
     
    if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi 

    #echo $TEMP

    #TODO: eval
    # Note the quotes around `$TEMP': they are essential!
    eval set -- "$TEMP"

    while true ; do
        case "$1" in 
             -a|--a-long) 
                echo "Option a:$1"
                shift ;; 
             -b|--b-long) 
                echo "Option b:$1,argument:$2"
                shift 2 ;;
             -c|--c-long)
                case "$2" in
                    "") echo "Option c:$1, no argument"; shift 2 ;;
                    *)  echo "Option c:$1, argument:$2"; shift 2 ;;
                esac ;;
              --)
                shift 
                break ;;
              *) echo "Internal error!,$1" ; exit 1 ;;
        esac
    done
    
    echo "Remaining arguments:" 
    for arg do echo "--> $arg" ; done 
    
    exit 0
}

#Key: test set/find cmd
# 
find_hard_links ()
{
    declare -r usage="Usage:\n
    ./functions file [search_dir]\n
    search files which hard link to filehd under search_dir\n
    filehd: the regular file,had more than 2 hard links\n
    search_dir: search directory\n"

    if [ $# != 1 -a $# != 2 ];then
        echo -e $usage
        exit 1
    fi

    if [ ! -f "$1" ];then
        echo "filehd must be regular file"
        exit 1
    fi

    if [ -n "$2" -a ! -d "$2" ];then
        echo "search_dir must be a directory"
        exit 1
    fi

    filehd="$1"

    if [ $# -eq 1 ];then
        dire="."
    else
        dire="$2"
    fi

    # set -- set positional parameter
    set -- $(ls -l "$filehd")

    linkcnt=$2
    if [ "$linkcnt" -eq 1 ];then
        echo "no other hard links to $filehd"
        exit 1;
    fi
    
    # get inod of filehd
    set $(ls -i "$filehd")

    inode=$1

    echo "links:using find to search for links..."
    #skip other file system,under search_dir
    find "$dire" -xdev -inum $inode -print
    
    exit 0
}

catch_int ()
{
    echo "got int signal"
    while true
    do
        echo "ctrl + z to exit";
    done
}

#Key: use trap to lock console
lockstty_with_trap ()
{
    # ignore the signals 
    trap "" SIGHUP SIGQUIT SIGCONT
    
    #catch ctrl+c signal
    trap "catch_int" SIGINT

    echo -n "key:"
    read k1
    echo -n "again:"
    read k2
    k3=0

    if [ "$k1" == "$k2" ];then
        echo "current pid= $$,ready to lock tty"
        sleep 3
        sync
        
        #disable "echo input characters"
        stty -echo
        
        #clear screen
        tput clear
        until [ "$k2" == "$k3" ]
        do
            #do nothing but read unlock key
            read k3
        done
    else
        echo "lock fail: key not match"
    fi
    
    #"echo input characters"
    stty echo
    
    exit 0
}

#Key: redirect stdout to file
redirect_stdout ()
{
    echo "save files under current directory into savethem"
    
    # redirect the stdout to savethem in current process
    exec >savethem
    # * means files/dirs under current directory
    for i in *
    do
        if [[ $i != "savethem" && ! -d "$i" ]];then 
            echo "=============================="
            echo "File: $i"
            echo "=============================="
            cat "$i"
        fi
    done
    #stdout to console
    exec > /dev/tty
}

#Key: alias "sudo minicom -C dynamic.log"
sminicom ()
{
    #add this function to ~/.bashrc
    #just execute: sminicom
    #can't use alias command in ~/.bashrc,because it will create the log file with the same name
    #echo `date` >> /home/niedaocai/a.txt
    sudo minicom -C "/home/niedaocai/logs/`date +%Y%m%d_%H%M%S`.log"
}

##### main function####

#first_func nie 123

#create_new_file 

#evaluate_expression

#test_example

#create_menu

#list_users

#ping_ip_group

#for_example 

#getopt_example "$@"

#find_hard_links "$@"

#lockstty_with_trap 

#redirect_stdout

#sminicom
