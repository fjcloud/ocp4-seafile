#!/bin/bash
source /opt/app-root/setenv.sh

chown -R default:root /opt/app-root/src/seafile-data/

$INSTALLPATH/seafile.sh start
$INSTALLPATH/seahub.sh start

tail -f $ROOTPATH/logs/ccnet.log &
tail -f $ROOTPATH/logs/seahub.log &
tail -f $ROOTPATH/logs/seafile.log &
tail -f $ROOTPATH/logs/controller.log &

maxretry=100
retry=0

while [ "$retry" -le "$maxretry" ]; do
    ps aux | grep seafile-controller | grep -v grep > /dev/null 2> /dev/null || {
        retry=$(expr $retry + 1);
    }
    sleep 5
done
echo "Seafile not running"
exit 1
