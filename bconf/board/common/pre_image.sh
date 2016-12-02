#!/bin/bash 

#echo $BR2_CONFIG
#echo $HOST_DIR
#echo $STAGING_DIR
#echo $TARGET_DIR
#echo $BUILD_DIR
#echo $BINARIES_DIR
#echo $BASE_DIR

target_dir=$1


if [ "x$BASE_DIR" = "x" ];then
	echo "Topdir not found."
	exit 1
fi
