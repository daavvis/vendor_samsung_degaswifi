#!/system/bin/sh

# disable fm headset, disable fm speaker
amixer -Dcodec csetn numid=38, 7405568 csetn numid=39, 7405568 csetn numid=12, 7405568 csetn numid=13, 7405568
