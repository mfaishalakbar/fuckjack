#!/bin/bash


#
# FUCK JACK
# Use with Android 7.X to 8.x
#

# Kill the Jack server
  printf "Fuck Jack...\n\n"
  sleep 1
  ./prebuilts/sdk/tools/jack-admin kill-server
  rm -rf ~/.jack*

# IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT!
#
# Replace the value in the first of "ANDROID_JACK_VM_ARGS" with half of your RAM
# (i.e.: if you have 8GB of ram, use "-Xmx4g")
#
    VM_ARGS="-Xmx4g -XX:+TieredCompilation -Dfile.encoding=UTF-8"
    
    export SERVER_NB_COMPILE=2
    export ANDROID_JACK_VM_ARGS=$VM_ARGS
    export JACK_SERVER_VM_ARGUMENTS=$VM_ARGS

#
# IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT! IMPORTANT!

# You may need to uncomment the following command if Java tells you to use it.
#  ulimit -n unlimited

  JACK_SERVER_JAR_NAME=$(ls prebuilts/sdk/tools/ | grep -E "jack-server-.+\.jar")
    ./prebuilts/sdk/tools/jack-admin install-server prebuilts/sdk/tools/jack-launcher.jar prebuilts/sdk/tools/$JACK_SERVER_JAR_NAME
    ./prebuilts/sdk/tools/jack-admin start-server
 if [ "$RAM_SIZE" -lt "4096000" ]
    then
sed -i -e "s/max-service\=[0-9][0-9]?/max-service\=$MAX_SVC/g" $HOME/.jack-server/config.properties
         sed -i -e "s/jack\.server\.max-service\.by-mem/\#jack\.server\.max-service\.by-mem/g" $HOME/.jack-server/config.properties
fi
