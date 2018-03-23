#! /bin/bash
#
DC_NB_SHARE="10.241.40.20"

PREFIX="nautilus smb://"
DAILY_BUILD_SERVER="10.241.14.92"
BSP_CLOUD="10.241.55.52"
WATCH_CLOUD="10.241.14.90"
YUN_SHARE="10.241.60.93"
LIXIN_SHARE="10.241.55.34"
DINGLEI_SHARE="10.241.60.39"
choice="q"

echox()
{
  echo -e "\e[0;91m$1\e[0m"
}

usage()
{
    echox "select smb:"
    echo "1.    daily build: public/geak     ${DAILY_BUILD_SERVER}"
    echo "2.    BSP Cloud:              ${BSP_CLOUD}"
    echo "3.    Watch Cloud: cloud/geak ${WATCH_CLOUD}"
    echo "4.    yun share:  ${YUN_SHARE}"
	echo "5.    lixin share: lixin/123456 ${LIXIN_SHARE}"
	echo "6.    dinglei share: ${DINGLEI_SHARE}"
    echo "7.    daocai nb share: ${DC_NB_SHARE}"

    echo "q.    quit"
}


read_input()
{
    while [ 1 ]
    do
        usage
        read -p "Enter:" choice
        case "${choice}" in
        1 | 2 | 3 | 4 | 5 | 6 | 7)
            break;;
        q | Q)
            exit;;
        *)
            echox "input error,input again!!\n"
            ;;
        esac
    done
}

do_smb()
{
    case "$1" in
    1)
        `${PREFIX}${DAILY_BUILD_SERVER}`;;
    2)
        `${PREFIX}${BSP_CLOUD}`;;
    3)
        `${PREFIX}${WATCH_CLOUD}`;;
    4)
        `${PREFIX}${YUN_SHARE}`;;
	5)
	`${PREFIX}${LIXIN_SHARE}`;;
	6)
	`${PREFIX}${DINGLEI_SHARE}`;;
    7)
	`${PREFIX}${DC_NB_SHARE} 2>&1 >/dev/zero`;;
    esac
}

read_input

do_smb ${choice}

echox "Done."
