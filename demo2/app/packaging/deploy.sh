#!/bin/bash
#Description: Script generating application package "platform dependant"

function help() {
    echo "Usage: $0 <platform>"
    echo "platform supported:"
    echo "lin64"
    echo "win64"
    echo "macos"
    echo "Example: $0 lin64"
}

if [ $# -ne 1 ]
then
    help
    exit 1
fi


PLATFORM=$1
if [ "$PLATFORM" != "lin64" ]
then
    if [ "$PLATFORM" != "win64" ]
    then
	if [ "$PLATFORM" != "macos" ]
	then
	    echo "Platform $1 not supported"
	    help
	    exit 1
	fi
    fi
fi

APP_NAME=PX504_BLOCKCHAIN_APP
cd $PLATFORM

#remove current package
rm -rf $APP_NAME $APP_NAME.zip
#create new package folder
mkdir $APP_NAME
#copy sources and binaries in package
mkdir $APP_NAME/app
cp -R ../../src/* $APP_NAME/app
cp content.txt $APP_NAME
cp ../*.json  $APP_NAME
cp geth* $APP_NAME
cp ../password $APP_NAME
cp setup* $APP_NAME

zip -r $APP_NAME.zip $APP_NAME
