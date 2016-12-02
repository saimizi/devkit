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
console_tty=`cat ${config} | grep "^BR2_TARGET_GENERIC_GETTY_PORT=" | sed "s/\"//g"  |  awk 'BEGIN{FS="/"}{print $NF}'`
mem=`cat ${config} | grep "^BR2_BF_MEMORY=" | sed "s/\"//g"  |  awk 'BEGIN{FS="="}{print $NF}'`
append=`cat ${config} | grep "^BR2_BF_BOOTARGS_APPEND=" | sed "s/\"//g"  | sed "s/^BR2_BF_BOOTARGS_APPEND=//"`
hostname=`cat ${config} | grep "^BR2_TARGET_GENERIC_HOSTNAME=" | sed "s/\"//g"  |  awk 'BEGIN{FS="="}{print $NF}'`
baudrate=`cat ${config} | grep "^BR2_TARGET_GENERIC_GETTY_BAUDRATE=" | sed "s/\"//g"  |  awk 'BEGIN{FS="="}{print $NF}'`
tftpboot_dir=`cat ${config} | grep "^BR2_BF_TFTP_DIR=" | sed "s/\"//g"  |  awk 'BEGIN{FS="="}{print $NF}'`

boot_method=`get_boot_method`
target_ip=$TARGET_IP
server_ip=$SERVER_IP
gateway_ip=$GATEWAY_IP
netmask_ip=$NETMASK

if [ "x$boot_method" = "xNFSBOOT" ];then
	cp ${BASE_DIR}/bconf/board/pandaboard_es/cmdline_nfs.txt uEnv.txt
fi

if [ "x$boot_method" = "xFLASH" ];then
	cp ${BASE_DIR}/bconf/board/pandaboard_es/cmdline_flash.txt uEnv.txt
fi

sed -i "s/<MEM>/$mem/; \
	s/<CONSOLE>/"$console_tty"/; \
	s/<BRATE>/$baudrate/; \
	s/<TARGET_IP>/$target_ip/; \
	s/<SERVER_IP>/$server_ip/; \
	s/<GATEWAY_IP>/$gateway_ip/; \
	s/<NETMASK_IP>/$netmask_ip/; \
	s/<HOSTNAME>/$hostname/; \
	s%<NFSROOTPATH>%${nfsroot_path}%; \
	s/<APPEND>/$append/" \
	uEnv.txt
mv uEnv.txt $tftpboot_dir

if [ ! -f ${BINARIES_DIR}/boot.scr ];then
	pwd
	cp ${BASE_DIR}/bconf/board/pandaboard_es/boot.script .
	sed -i "s/<TARGET_IP>/$target_ip/; \
		s/<SERVER_IP>/$server_ip/;" \
		boot.script
		
	${HOST_DIR}/usr/bin/mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "PandaBoard ES Boot Image" -d boot.script boot.scr
	mv boot.scr ${BINARIES_DIR}/
	rm boot.script
fi



. ${BASE_DIR}/bconf/board/common/post_image.sh

