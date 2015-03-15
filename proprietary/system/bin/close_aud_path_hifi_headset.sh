#!/system/bin/sh

# disable hifi speaker and headset, 0x8030064
amixer -Dcodec csetn numid=29, 7405568 csetn numid=30, 7405568 csetn numid=3, 7405568 csetn numid=4, 7405568
