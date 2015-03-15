#!/system/bin/sh

stop eeh-nvm-diag
stop atcmdsrv
stop audioserver

logwrapper rmmod cidatattydev
logwrapper rmmod seh
logwrapper rmmod gs_diag
logwrapper rmmod diag
logwrapper rmmod gs_modem
logwrapper rmmod ccinetdev
logwrapper rmmod cci_datastub
logwrapper rmmod msocketk
logwrapper rmmod citty
echo 0 > /sys/devices/system/cpu/cpu0/cp
logwrapper rmmod cploaddev
