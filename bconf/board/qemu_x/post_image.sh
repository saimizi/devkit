#!/bin/bash

#echo $BR2_CONFIG
#echo $HOST_DIR
#echo $STAGING_DIR
#echo $TARGET_DIR
#echo $BUILD_DIR
#echo $BINARIES_DIR
#echo $BASE_DIR

if [ "x$BASE_DIR" = "x" ];then
	echo "Topdir not found."
	exit 1
fi

config=${BASE_DIR}/.config

get_boot_method(){
	method=`cat $config | grep "^BR2_BF_BOOT_METHOD_"`
	if [ "x$method" != "x" ];then
		sel=`echo $method | awk 'BEGIN{FS="="}{print $2}'`
		result=`echo $method | awk 'BEGIN{FS="="}{print $1}'`
		result=${result##BR2_BF_BOOT_METHOD_}
		if [ "x$sel" = "xy" ];then
			echo $result
		fi
	fi
}

nfsroot_path=$2
mem=`cat ${config} | grep "^BR2_BF_MEMORY=" | sed "s/\"//g"  |  awk 'BEGIN{FS="="}{print $NF}'`
append=`cat ${config} | grep "^BR2_BF_BOOTARGS_APPEND=" | sed "s/\"//g"  | sed "s/^BR2_BF_BOOTARGS_APPEND=//"`
hostname=`cat ${config} | grep "^BR2_TARGET_GENERIC_HOSTNAME=" | sed "s/\"//g"  |  awk 'BEGIN{FS="="}{print $NF}'`

boot_method=`get_boot_method`

if [ "x$boot_method" = "xNFSBOOT" ];then
	cp ${BASE_DIR}/bconf/board/pandaboard_es/cmdline_nfs.txt uEnv.txt

	cp ${BASE_DIR}/bconf/board/qemu_x/cmd.sh ${BASE_DIR}/
	sed -i "s/<MEM>/$mem/; \
		s/<HOSTNAME>/$hostname/; \
		s%<NFSROOTPATH>%${nfsroot_path}%; \
		s/<APPEND>/$append/" \
		${BASE_DIR}/cmd.sh
fi

. ${BASE_DIR}/bconf/board/common/post_image.sh

