#! /bin/bash
#
SANGO_BUILD_SERVER="10.241.10.101"
SANGO_BUILD_SVR2="10.241.10.117"
MY_ROUTER="192.168.18.1"
GK_JENKINS="10.241.14.92"
GK_90="10.241.14.90"
PRODUCT_ENV_LOG_109="120.132.94.109"
BACKUP_LOG_108="10.241.10.108"
TEST_ENV_LOG_113="120.132.94.113"

USR_NIE="niedaocai"
USR_MATRIX="matrix"
USR_GK_JENKINS="jenkins"
USR_ROOT="root"
USR_UBUNTU="ubuntu"

choice="q"

echox()
{
  echo -e "\e[0;91m$1\e[0m"
}

usage()
{
    echox "select which ssh:"
    echo "1.    sango build server: ${USR_NIE} ${SANGO_BUILD_SERVER}"
    echo "2.    my test router: ${USR_MATRIX}/${USR_MATRIX} ${MY_ROUTER}"
    echo "3.    geak watch jenkins: ${USR_GK_JENKINS}/jenkinspwd ${GK_JENKINS}"
    echo "4.    geak 90 server: ${USR_ROOT}/Snda150817 ${GK_90}"
    echo "5.    sango httpDot portal log, 109 server<product>: ${USR_NIE} ${PRODUCT_ENV_LOG_109}"
    echo "6.    sango httpDot portal log, 108 server<local backup>: ${USR_NIE} ${BACKUP_LOG_108}"
    echo "7.    sango httpDot portal log, 113 server<test>: ${USR_NIE} ${TEST_ENV_LOG_113}"
    echo "8.    sango build server 2 ${USR_UBUNTU} ${SANGO_BUILD_SVR2}"

    echo "q.    quit"
}


read_input()
{
    while [ 1 ]
    do
        usage
        read -p "Enter:" choice
        case "${choice}" in
        1 | 2 | 3 | 4 | 5 | 6 | 7 | 8)
            break;;
        q | Q)
            exit;;
        *)
            echox "input error,input again!!\n"
            ;;
        esac
    done
}

do_ssh_login()
{
    case "$1" in
    1)
	 ssh ${USR_NIE}@${SANGO_BUILD_SERVER} -p 48422;;
    2)
	#wget ${MY_ROUTER}/api/ssh_open_123321679
	#curl http://${MY_ROUTER}/api/ssh_open_123321679
	#sleep 1
	#ssh-keygen -f "/home/niedaocai/.ssh/known_hosts" -R ${MY_ROUTER}
	ssh ${USR_MATRIX}@${MY_ROUTER};;
    3)
	 ssh ${USR_GK_JENKINS}@${GK_JENKINS};;
    4)
	 ssh ${USR_ROOT}@${GK_90};;
    5)
	 ssh ${USR_NIE}@${PRODUCT_ENV_LOG_109} -p 48422;;
    6)
        ssh ${USR_NIE}@${BACKUP_LOG_108} -p 48422;;
    7)
        ssh ${USR_NIE}@${TEST_ENV_LOG_113} -p 48422;;
    8)
        ssh ${USR_UBUNTU}@${SANGO_BUILD_SVR2};;
    esac
}

read_input

do_ssh_login ${choice}

echox "Done."
