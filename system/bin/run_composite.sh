#!/system/bin/sh

setprop sys.telephony.default.loglevel 8

MODULE_DIR=/lib/modules
insmod $MODULE_DIR/msocketk.ko
insmod $MODULE_DIR/cploaddev.ko
insmod $MODULE_DIR/seh.ko
# load cp and mrd image and release cp
/system/bin/cploader

ret="$?"


if [ ! -e $NVM_ROOT_DIR ]; then
	mkdir -p $NVM_ROOT_DIR
	chown system.system $NVM_ROOT_DIR
fi

if [ ! -e $MARVELL_RW_DIR ]; then
	mkdir -p $MARVELL_RW_DIR
	chown system.system $MARVELL_RW_DIR
	chmod 0755 $MARVELL_RW_DIR
fi

case "$ret" in
	    "-1")
		rmmod seh
		rmmod cploaddev
		rmmod msocketk
		stop ril-daemon
		exit -1
       ;;
	    "1")
		rmmod seh
		rmmod cploaddev
		rmmod msocketk
		stop ril-daemon
		start nvm-aponly
		start diag-aponly
		insmod $MODULE_DIR/citty.ko
		start atcmdsrv-aponly
		exit 1
       ;;
       *)
       ;;
esac

# $1 src file
# $2 dst file
function copy_if_not_exist()
{
if [ -f "${2}" ]; then
	echo "existing ${2}";
else
	if [ -f "${1}" ]; then
		cp ${1} ${2}
		chmod 666 ${2}
		chown system.system ${2}
		echo "cp: ${1} -> ${2}"
	fi
fi
}

kernel_cmdline=`cat /proc/cmdline`

T7_BOARDID="board_id=0x7"

function is_t7_board()
{
	if [[ "$kernel_cmdline" == *$T7_BOARDID* ]]
	then
		return 0
	else
		return 1
	fi
}

# copy correct RF config file for CP
# pxa986 T7 board -> T7 specific
cputype=`cat /sys/devices/system/cpu/cpu0/cputype`
case "$cputype" in
    "pxa986ax"|"pxa986zx"|"pxa1088")
	if is_t7_board; then
		rfcfg_src="rfcfg/LyraConfig_T7.nvm"
		rfcfg_dst="LyraConfig.nvm"
	else
		rfcfg_src=""
		rfcfg_dst=""
	fi
	;;
	*)
	rfcfg_src=""
	rfcfg_dst=""
	;;
esac

# copy COMCfg.csv
string=`getprop`;
if [[ $string == *SM-T232* ]] 
then
	nvm_src="ttc/degas3gjv/COMCfg.csv"
else
	nvm_src="ttc/COMCfg.csv"
fi
nvm_dst="COMCfg.csv"
copy_if_not_exist "/etc/tel/${nvm_src}" "${NVM_ROOT_DIR}/${nvm_dst}"
chown system system $NVM_ROOT_DIR/$nvm_dst
chmod 0666 $NVM_ROOT_DIR/$nvm_dst

# copy DipChannelChange.nvm file for CP
nvm_src="ttc/DipChannelChange.nvm"
nvm_dst="DipChannelChange.nvm"
copy_if_not_exist "/etc/tel/${nvm_src}" "${NVM_ROOT_DIR}/${nvm_dst}"
chown system system $NVM_ROOT_DIR/$nvm_dst
chmod 0644 $NVM_ROOT_DIR/$nvm_dst

# copy DipChannelChange.nvm file for CP
nvm_src="ttc/LyraConfig.nvm"
nvm_dst="LyraConfig.nvm"
copy_if_not_exist "/etc/tel/${nvm_src}" "${NVM_ROOT_DIR}/${nvm_dst}"
chown system system $NVM_ROOT_DIR/$nvm_dst
chmod 0644 $NVM_ROOT_DIR/$nvm_dst

# copy TTPCom_NRAM2_ABMM_WRITEABLE_DATA.gki file for CP
nvm_src="ttc/TTPCom_NRAM2_ABMM_WRITEABLE_DATA.gki"
nvm_dst="TTPCom_NRAM2_ABMM_WRITEABLE_DATA.gki"
copy_if_not_exist "/etc/tel/${nvm_src}" "${NVM_ROOT_DIR}/${nvm_dst}"
chown system system $NVM_ROOT_DIR/$nvm_dst
chmod 0644 $NVM_ROOT_DIR/$nvm_dst

# copy RFPmaxReductionConfig.nvm file for CP
nvm_src="ttc/RFPmaxReductionConfig.nvm"
nvm_dst="RFPmaxReductionConfig.nvm"
copy_if_not_exist "/etc/tel/${nvm_src}" "${NVM_ROOT_DIR}/${nvm_dst}"
chown system system $NVM_ROOT_DIR/$nvm_dst
chmod 0644 $NVM_ROOT_DIR/$nvm_dst

# copy audio calibration files to NVM if not exist
audio_avc="audio_avc.nvm"
audio_config="audio_config.nvm"
audio_ctm="audio_ctm.nvm"
audio_diamond="audio_diamond.nvm"
audio_DualMic="audio_DualMic.nvm"
audio_ec="audio_ec.nvm"
audio_effect_config="audio_effect_config.xml"
audio_eq="audio_eq.nvm"
audio_gain_calibration="audio_gain_calibration.xml"
audio_gssp_config="audio_gssp_config.nvm"
audio_HLPF="audio_HLPF.nvm"
audio_misc="audio_misc.nvm"
audio_MSAmain="audio_MSAmain.nvm"
audio_ns="audio_ns.nvm"
audio_swvol_calibration="audio_swvol_calibration.xml"
copy_if_not_exist "/etc/tel/${audio_avc}" "${NVM_ROOT_DIR}/${audio_avc}"
copy_if_not_exist "/etc/tel/${audio_config}" "${NVM_ROOT_DIR}/${audio_config}"
copy_if_not_exist "/etc/tel/${audio_ctm}" "${NVM_ROOT_DIR}/${audio_ctm}"
copy_if_not_exist "/etc/tel/${audio_diamond}" "${NVM_ROOT_DIR}/${audio_diamond}"
copy_if_not_exist "/etc/tel/${audio_DualMic}" "${NVM_ROOT_DIR}/${audio_DualMic}"
copy_if_not_exist "/etc/tel/${audio_ec}" "${NVM_ROOT_DIR}/${audio_ec}"
copy_if_not_exist "/etc/tel/${audio_effect_config}" "${NVM_ROOT_DIR}/${audio_effect_config}"
copy_if_not_exist "/etc/tel/${audio_eq}" "${NVM_ROOT_DIR}/${audio_eq}"
copy_if_not_exist "/etc/tel/${audio_gain_calibration}" "${NVM_ROOT_DIR}/${audio_gain_calibration}"
copy_if_not_exist "/etc/tel/${audio_gssp_config}" "${NVM_ROOT_DIR}/${audio_gssp_config}"
copy_if_not_exist "/etc/tel/${audio_HLPF}" "${NVM_ROOT_DIR}/${audio_HLPF}"
copy_if_not_exist "/etc/tel/${audio_misc}" "${NVM_ROOT_DIR}/${audio_misc}"
copy_if_not_exist "/etc/tel/${audio_MSAmain}" "${NVM_ROOT_DIR}/${audio_MSAmain}"
copy_if_not_exist "/etc/tel/${audio_ns}" "${NVM_ROOT_DIR}/${audio_ns}"
copy_if_not_exist "/etc/tel/${audio_swvol_calibration}" "${NVM_ROOT_DIR}/${audio_swvol_calibration}"
# end copy audio calibration

copy_if_not_exist "/etc/tel/${rfcfg_src}" "${NVM_ROOT_DIR}/${rfcfg_dst}"


insmod $MODULE_DIR/citty.ko
insmod $MODULE_DIR/cci_datastub.ko
insmod $MODULE_DIR/ccinetdev.ko
insmod $MODULE_DIR/gs_modem.ko
insmod $MODULE_DIR/diag.ko
insmod $MODULE_DIR/gs_diag.ko
insmod $MODULE_DIR/cidatattydev.ko
insmod $MODULE_DIR/usimeventk.ko

sync

start eeh
start nvm
start diag
start atcmdsrv
start vcm

# for usimevent
sleep 1
chown radio:system /sys/devices/virtual/usim_event/usim0/enable
chown radio:system /sys/devices/virtual/usim_event/usim0/send_event
chmod 0660 /sys/devices/virtual/usim_event/usim0/enable
chmod 0660 /sys/devices/virtual/usim_event/usim0/send_event

exit 0

