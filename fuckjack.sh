#!/bin/bash

#
# The "Fuck Jack" bash script
#
# For AOSP versions 7.0 to 8.x
#
# Written by Michael S Corigliano (Mike Criggs) (michael.s.corigliano@gmail.com)
# Taken & adapted from my EZ AOSP tool, available here: https://github.com/mikecriggs/ez-aosp
# Ported for building LineageOS by https://github.com/mfaishalakbar
#
# You may use this script and/or any part of it without any permission in your own projects
#
# Usage: ./fuckjack.sh
#

# Colors for terminal output
  BLDRED="\033[1m""\033[31m"
  RST="\033[0m"

# Do we want to use NINJA?
  if(whiptail --title "FUCK JACK" --yesno "Would you like to use NINJA to compile the source code?" 10 70) then
    echo -e ${BLDRED}"Compiling with NINJA..."${RST}
    sleep 3
  else
    echo -e ${BLDRED}"Not compiling with NINJA..."${RST}
    sleep 3
    export USE_NINJA=false
  fi

# Do we need to use JACK workarounds?
  if(whiptail --title "FUCK JACK" --yesno "If your machine has less than 16GB of RAM, we may need to use some JACK workarounds. Would you like to use these?" 30 70) then
    echo -e ${BLDRED}"Using JACK workarounds..."${RST}
    sleep 3
    ./prebuilts/sdk/tools/jack-admin kill-server
    rm -rf ~/.jack*

# IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT!
#
# Replace the value in the first of "ANDROID_JACK_VM_ARGS" with half of your ram
# (i.e.: if you have 8GB of ram, use "-Xmx4g")
#
    VM_ARGS="-Xmx4g -XX:+TieredCompilation -Dfile.encoding=UTF-8"
    
    export SERVER_NB_COMPILE=2
    export ANDROID_JACK_VM_ARGS=$VM_ARGS
    export JACK_SERVER_VM_ARGUMENTS=$VM_ARGS

#
# IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT!

# You may need to uncomment the following command if Java tells you to use it.
#     ulimit -n unlimited
    
    JACK_SERVER_JAR_NAME=$(ls prebuilts/sdk/tools/ | grep -E "jack-server-.+\.jar")
    ./prebuilts/sdk/tools/jack-admin install-server prebuilts/sdk/tools/jack-launcher.jar prebuilts/sdk/tools/$JACK_SERVER_JAR_NAME
    ./prebuilts/sdk/tools/jack-admin start-server
    
    RAM_SIZE=$(cat /proc/meminfo | grep "MemTotal" | rev | cut -d' ' -f2 | rev)
    if [ "$RAM_SIZE" -lt "4096000" ]
    then
       if(whiptail --title "FUCK JACK" --yesno "RAM Less than 4GB. Would you like to use Low RAM Build Mode. Building might be Slow but it works, somehow." 20 60) then
         echo -e ${BLDRED}"Make sure you have enough Swap to build."${RST}
         MAX_SVC=2
         sed -i -e "s/max-service\=[0-9][0-9]?/max-service\=$MAX_SVC/g" $HOME/.jack-server/config.properties
         sed -i -e "s/jack\.server\.max-service\.by-mem/\#jack\.server\.max-service\.by-mem/g" $HOME/.jack-server/config.properties
       fi
    fi

  else
    echo -e ${BLDRED}"Not using JACK workarounds..."${RST}
    sleep 3
  fi

# Do we want to build clean?
  if(whiptail --title "FUCK JACK" --yesno "Would you like to build clean? If you used JACK workarounds, it is recommended to do so or your build may fail." 30 70) then
    echo -e ${BLDRED}"Building clean..."${RST}
    sleep 3
    make clean
    clear
  else
    echo -e ${BLDRED}"Not building clean..."${RST}
    sleep 3
  fi
