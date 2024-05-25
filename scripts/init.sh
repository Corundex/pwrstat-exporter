#!/bin/bash

echo ===========================================================================
date
echo ===========================================================================
/etc/init.d/pwrstatd start
sleep 1
echo ===========================================================================

if [ "$ALARM" = "on" ]; then
    pwrstat -alarm on
    echo "Alarm turned on."
    elif [ "$ALARM" = "off" ]; then
    pwrstat -alarm off
    echo "Alarm turned off."
fi

pwrstat -config
echo ===========================================================================
pwrstat -status
echo ===========================================================================
/app/pwrstat-exporter