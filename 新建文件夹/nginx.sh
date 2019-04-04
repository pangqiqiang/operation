#!/bin/bash
HOST="${1%%|*}"
PORT="${1##*|}"
function ping {
/sbin/pidof nginx | wc -l
}
function active() {
/usr/bin/curl -s "http://$HOST:$PORT/status/" 2>/dev/null| grep 'Active' | awk '{print $NF}'
}
function accepts() {
/usr/bin/curl -s "http://$HOST:$PORT/status/" 2>/dev/null| awk NR==3 | awk '{print $1}'
}
function handled() {
/usr/bin/curl -s "http://$HOST:$PORT/status/" 2>/dev/null| awk NR==3 | awk '{print $2}'
}
function requests() {
/usr/bin/curl -s "http://$HOST:$PORT/status/" 2>/dev/null| awk NR==3 | awk '{print $3}'
}
function reading() {
/usr/bin/curl -s "http://$HOST:$PORT/status/" 2>/dev/null| grep 'Reading' | awk '{print $2}'
}
function writing() {
/usr/bin/curl -s "http://$HOST:$PORT/status/" 2>/dev/null| grep 'Writing' | awk '{print $4}'
}
function waiting() {
/usr/bin/curl -s "http://$HOST:$PORT/status/" 2>/dev/null| grep 'Waiting' | awk '{print $6}'
}

case "$2" in
active)
	active
	;;
accepts)
	accepts
	;;
handled)
	handled
	;;
requests)
	requests
	;;
reading)
	reading
	;;
writing)
	writing
	;;
waiting)
	waiting
	;;
*)
	echo $"Usage $0 {active|accepts|handled|requests|reading|writing|waiting}"
	exit
esac