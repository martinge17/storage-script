#!/usr/bin/env bash
#Author: martinge17 https://github.com/martinge17


# AWK IS REQUIRED

#Variables

bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
yellow=$(tput setaf 2)

unset initSys #

TARGET_PATH="/"
STORAGE_WARNING=10485760  # In kbytes 10G = 10G*1024MB*1024k  10485760  31457280

# Functions


checkDependency(){

    command -v "$1" >/dev/null 2>&1 # Writes output o null

}


# Check if system uses systemd

checkInitSystem(){ #This script only supports systemd

    #if ps -p1 | grep -cw 'systemd'; then  #Check using grep
    #    echo "YESSSSS"
    #fi

    if [[ $(ps -p1) = *systemd* ]]; then #Check using pure bash
        initSys="systemd"
    else
        initSys="null"
    fi

}


showBootInfo(){

    if [[ "$initSys" == "systemd" ]]; then
         #echo $(systemd-analyze)
         systemd-analyze
    else
         echo -e "${red}Error:${normal} Boot Information only supported on ${yellow}Systemd${normal} at the moment :("
    fi

}


showStorageInfo(){

    local FREE=$(df -k $TARGET_PATH | awk 'NR==2{print $4}') # df -k not df -h

    local FREE_HUMAN=$(df -h $TARGET_PATH | awk 'NR==2{print $4}')

    if [[ $FREE -lt $STORAGE_WARNING ]]; then # 10G = 10G*1024MB*1024k
        echo "${red}Warning!!${normal} Availible storage at '$TARGET_PATH': ${red} $FREE_HUMAN ${normal}"
    else
        echo "Availible storage at '$TARGET_PATH': ${yellow} $FREE_HUMAN ${normal}"
    fi


}


echo -e "${bold}>---------------- YASIS (Yet Another System Info Script) ----------------<${normal}\n" # -e Enable interpretation of backslash escapes

echo "Date is: $(date)" #Print date


echo -e  "\n${bold}Boot Information${normal}"

checkInitSystem #Check Init System

showBootInfo #Show boot info


echo -e  "\n${bold}Storage Info${normal}"


    if checkDependency awk; then
        showStorageInfo
    else
        echo -e "${red}Missing Dependencies:${normal} awk"
    fi


echo -e "${bold}>------------------------------------------------------------------------<${normal}\n" # -e Enable interpretation of backslash escapes



