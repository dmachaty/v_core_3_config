#!/bin/sh

ret=1
timeout=0
host=0.0.0.0
echo -n "Waiting for xserver to be ready " | systemd-cat
while [ $ret -gt 0 ] && [ $timeout -lt 60 ]
do
  # Get list of active IPs
  echo Getting list of active IPs on network
  list=`nmap -p 6000 -n 10.230.81.0/24 -oG - | awk '/open/{print $2}'`
  echo List of active IPs: | systemd-cat
  echo $list | systemd-cat

  # Scan for active xsever
  for ilist in $list
  do
    echo Scanning IP $ilist for xserver
    xset -display $ilist:0 -q > /dev/null 2>&1
    ret=$?
    if [ $ret -gt 0 ]
    then
      echo Xserver not found, going on
    else
      echo XServer found! | systemd-cat
      host=$ilist
      echo Host IP: $host | systemd-cat
    fi
  done

  if [ $ret -lt 1 ]
  then
    echo Breaking cycle
    break
  fi
  timeout=$( expr $timeout + 1 )
  echo "Repeating scan"
  sleep 1
done

echo ""

if [ $timeout -lt 60 ]
then
  DISPLAY=$host:0 /home/pi/.KlipperScreen-env/bin/python /home/pi/KlipperScreen/screen.py
  exit 0
else
  exit 1
fi
