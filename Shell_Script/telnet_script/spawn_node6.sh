#!/bin/sh
echo open node6 2605
sleep 1
echo zebra
sleep 1
echo en
sleep 1
echo conf t
sleep 1
echo router bgp 60007
sleep 1
echo srx connect node5 17900
sleep 1
echo exit
