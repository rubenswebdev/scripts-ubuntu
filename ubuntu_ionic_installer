#!/bin/bash
# Ubuntu Developer Script For Ionic Framework
# Created by Nic Raboy
# http://www.nraboy.com
#
# Updated by Rubens Fernnandes - 02-06-2015
# http://websix.com.br
#
#
# Downloads and configures the following:
#
#   Java JDK
#   Apache Ant
#   Android
#   NPM
#   Apache Cordova
#   Ionic Framework

HOME_PATH=$(cd ~/ && pwd)
INSTALL_PATH=~/
ANDROID_SDK_PATH=~/android-sdk

# x86_64 or i686
LINUX_ARCH="$(lscpu | grep 'Architecture' | awk -F\: '{ print $2 }' | tr -d ' ')"

# Latest Android Linux SDK for x64 and x86 as of 02-06-2015
ANDROID_SDK="https://dl.google.com/android/android-sdk_r24.0.2-linux.tgz"

#Desktop is default in linux English version, but in another language that folder not exist
cd ~/

if [ ! -f android-sdk.tgz ]; then
    echo "File not found!"
	wget "$ANDROID_SDK" -O "android-sdk.tgz"
fi

if [ ! -d android-sdk ]; then
	tar zxf "android-sdk.tgz" -C "$INSTALL_PATH"
	cd "$INSTALL_PATH" &&  mv "android-sdk-linux" "android-sdk"
fi
# Android SDK requires some x86 architecture libraries even on x64 system
apt-get install -y libc6:i386 libgcc1:i386 libstdc++6:i386 libz1:i386

cd "$INSTALL_PATH" &&  chown root:root "android-sdk" -R
cd "$INSTALL_PATH" &&  chmod 777 "android-sdk" -R

cd ~/

# Add Android and NPM paths to the profile to preserve settings on boot
echo "export PATH=\$PATH:$ANDROID_SDK_PATH/tools" >> ".profile"
echo "export PATH=\$PATH:$ANDROID_SDK_PATH/platform-tools" >> ".profile"

# Install JDK and Apache Ant
apt-get -y install default-jdk ant

# Set JAVA_HOME based on the default OpenJDK installed
export JAVA_HOME="$(find /usr -type l -name 'default-java')"
if [ "$JAVA_HOME" != "" ]; then
    echo "export JAVA_HOME=$JAVA_HOME" >> ".profile"
fi

echo "Instalando NODEJS 4.x"
apt-get -y install curl
curl -sL https://deb.nodesource.com/setup_4.x | sudo bash -
apt-get update
apt-get install -y nodejs

# Install Apache Cordova and Ionic Framework
npm install -g cordova
npm install -g ionic

echo "----------------------------------"
echo "Restart your Ubuntu session for installation to complete..."