#!/bin/bash
lid_status=`cat /proc/acpi/button/lid/LID/state | awk '{print $2}'`

if [ "$lid_status" == 'closed' ]; then
    logger "ACPI: LID CLOSE Script"
    /home/domazet/.screenlayout/lid_close.sh
else
    logger "ACPI: LID OPEN Script"
    /home/domazet/.screenlayout/lid_open.sh
fi
