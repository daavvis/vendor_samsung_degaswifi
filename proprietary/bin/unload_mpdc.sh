#! /system/bin/sh

echo "Unloading Marvell Code Performance Analyzer Drivers ..."

DRVS="mpdc_cm mpdc_hs mpdc_css mpdc_tp"

ret=0

PWD=`pwd`

for drv in $DRVS; do

	if cd /sys/module/$drv > /dev/null 2>&1 
	then
		rmmod $drv

		case "$?" in
			0)
			;;
			*) ret=$?
			;;
		esac
	fi
	
done

case $ret in
	0) echo "Succeeded to unload the drivers!"
	;;
	*) echo "Failed to unload the drivers!"
	;;
esac

exit $ret