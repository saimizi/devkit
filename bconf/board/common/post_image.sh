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

nfs_root_path=$2
echo ${nfs_root_path}

if [ "x$nfs_root_path" != "x" ];then
	if [ ! -d "${nfs_root_path}" ];then
		mkdir -p  $nfs_root_path
	fi

	if [ -d "${nfs_root_path}" ];then
		fakeroot rsync -lpuacDHPE --chmod=a-s --exclude-from=${BASE_DIR}/bconf/rsync.exclude ${TARGET_DIR}/*  ${nfs_root_path}/  | grep -v "\/$"
	fi
fi

${HOST_DIR}/usr/bin/qemu-arm -L $nfs_root_path  `find ${HOST_DIR}/ -name "ldconfig"` -r $nfs_root_path

echo
echo "All built sucessfully."



