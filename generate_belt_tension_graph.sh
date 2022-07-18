#!/bin/sh

sleep 10

/home/pi/klipper/scripts/graph_accelerometer.py -c /tmp/raw_data_axis*_belt-tension-*.csv -o /home/pi/belt-tension-resonances-$( date +'%Y-%m-%d-%H%M%S' ).png
