#!/bin/bash

MONIT_HOME='/usr/local/monit'

function start {
  $MONIT_HOME/bin/monit -c $MONIT_HOME/conf/monitrc
}

function stop {
  kill -9 `ps -ef | grep monit/bin/monit | grep -v "grep" | awk '{print $2}' `
}

case $1 in
'start')
  start
;;
'stop')
  stop
;;
'restart')
  stop
  sleep 2
  start
;;
*)
  echo "USAGE $0 start|stop|restart"
esac
