#!/bin/bash

qemu-system-x86_64 \
	-m <MEM> \
	-cpu qemu64 \
	-kernel images/bzImage \
	--append "raid=noautodetect console=ttyS0 root=/dev/nfs nfsroot=10.0.2.2:<NFSROOTPATH> rw ip=10.0.2.15::10.0.2.1:255.255.255.0:<HOSTNAME> <APPEND>" \
	-nographic

