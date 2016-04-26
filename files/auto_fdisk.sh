#!/bin/bash
# Format disk
#

TGTDEV=$1
TGTDIR=$2

if [[ $TGTDEV == "" ]]; then
	echo input device null
	exit 1
fi

if [[ $TGTDIR == "" ]]; then
	echo input mount point null
	exit 1
fi

ret=`grep -c /dev/vg0/lv0 /etc/fstab`
if [ $ret -ne 0 ]; then
    echo fdisk have already done!
	exit 0
fi

echo begin fdisk ${TGTDEV}

echo -e "n\np\n1\n\n\nw" | fdisk ${TGTDEV}

# begin create pv
pvcreate ${TGTDEV}1
pvdisplay
# begin create vg
vgcreate vg0 ${TGTDEV}1
vgdisplay
# begin create lv
lvcreate -l 100%FREE -n lv0 vg0

mkfs.ext4 /dev/vg0/lv0
mkdir -p $TGTDIR
echo "/dev/vg0/lv0  $TGTDIR ext4    defaults    0  0" >> /etc/fstab
mount -a
