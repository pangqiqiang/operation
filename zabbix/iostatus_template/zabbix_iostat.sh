#!/bin/bash

ZBX_DEV="$1"
ZBX_METRIC="$2"
TEMP_LOG="/tmp/iostat.tmp"
IOSTAT_LOG="/home/work/app/zabbix/logs/monitor_logs/iostat.log"
LOG_BASE=${IOSTAT_LOG%/*}
[ -d $LOG_BASE ] || mkdir -p ${LOG_BASE}
[ -f $IOSTAT_LOG ] || touch ${IOSTAT_LOG}
# Check iostat util
if ! which iostat >/dev/null 2>&1; then
  >&2 echo "Can't find 'iostat' binary in \$PATH"
  >&2 echo "Make sure that you've installed 'sysstat' package"
  exit 1
fi

# Check args
[[ $# -lt 1 ]] && { echo "Give some more arguments, please :)"; exit 1; }

# Discovering devices and spits out JSON
if [ "$ZBX_DEV" = 'discovery' ]; then
  iostat -d | \
  tail -n +4 | 
  awk 'BEGIN { 
    ORS=""; 
    print "{\"data\":["} 
    /\d/ {printf "%s{\"%s\":\"%s\"}", separator, "{#DEVICENAME}", $1, separator = ","} 
    END {print "]}" }'
  exit 0
fi

last_gen_time=$(stat -c %Y ${IOSTAT_LOG})
exec_time=$(date +%s)
delt_time=$(( $exec_time - $last_gen_time))
if [ $delt_time -ge 30 ];then
	iostat -dxk 1 20 > ${TEMP_LOG} && cp -a  ${TEMP_LOG} ${IOSTAT_LOG}
fi
# Parse iostat file
function parse_iostat() {
  grep ${ZBX_DEV} ${IOSTAT_LOG} | \
  tr ',' '.' | \
  awk -v field="$1" '
  {sum+=$field; n++;} 
  END {if (n > 0) print sum/n; 
  else {print "[m|ZBX_NOTSUPPORTED] [Nodata.]" > "/dev/stderr"; exit 1};}'
}

# Exec parse funcion with number of column
case ${ZBX_METRIC} in
  rrqm/s    ) parse_iostat '2';;
  wrqm/s    ) parse_iostat '3';;
  r/r       ) parse_iostat '4';;
  w/r       ) parse_iostat '5';;
  rkb/s     ) parse_iostat '6';;
  wkb/s     ) parse_iostat '7';;
  avgrq-sz  ) parse_iostat '8';;
  avgqu-sz  ) parse_iostat '9';;
  await     ) parse_iostat '10';;
  r_await   ) parse_iostat '11';;
  w_await   ) parse_iostat '12';;
  svctm     ) parse_iostat '13';;
  util      ) parse_iostat '14';;
  *         ) echo "[m|ZBX_NOTSUPPORTED] [Unsupported item key.]" && exit 1;;
esac




