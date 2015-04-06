#!/bin/bash


DATE_FORMAT="%Y-%m-%d %H:%M:%S"
SLEEP_TIME=15m


usage_exit() {
    echo "usage: $0 [-t SLEEPTIME] [FILENAME]" 1>&2
    exit 1
}

get_charnum() {
    echo `wc -m < $1`
}

generate_msg() {
    echo "$SLEEP_TIMEで書いた文字数: $1文字"
    echo "総文字数: $2文字"
}


while getopts t:h OPT
do
    case $OPT in
        t) SLEEP_TIME=$OPTARG
            ;;
        h) usage_exit
            ;;
        \?) usage_exit
            ;;
    esac
done
shift $((OPTIND - 1))

if [ $# -ne 1 ]; then
    usage_exit
fi


CHNUM_PREV=`get_charnum $1`

while [ 1 ]
do
    sleep $SLEEP_TIME
    if [ $? -ne 0 ]; then
        usage_exit
    fi

    CHNUM=`get_charnum $1`
    CHDIFF=`expr $CHNUM - $CHNUM_PREV`
    notify-send \
        "[`date +"$DATE_FORMAT"`]" \
        "`generate_msg $CHDIFF $CHNUM`"

    echo "[`date +"$DATE_FORMAT"`]" \
         $SLEEP_TIME \
         $CHDIFF \
         $CHNUM
    
    CHARNUM=$TMPCHNUM
done
