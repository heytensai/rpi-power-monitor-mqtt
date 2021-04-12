#!/bin/bash

[ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -en "$0" "$0" "$@" || :

HOST="${1}"
PREFIX="${2}"

for ct in $(seq 0 5)
do
	w=$(influx -database power_monitor -execute "select last(power) from raw_cts where ct = '${ct}' and time > now() - 1m group by power fill(0) limit 1" -format csv |grep ^raw_cts |perl -lpe 's/.*,//; s/(\..).*/$1/; $_=0 if ($_<0);')
	mosquitto_pub -h "${1}" -t "${PREFIX}/ct_${ct}/power" -m "${w}"
done

homeload=$(influx -database power_monitor -execute "select last(power) from home_load where time > now() - 1m group by power fill(0) limit 1" -format csv |grep ^home_load |perl -lpe 's/.*,//; s/(\..).*/$1/')
mosquitto_pub -h "${1}" -t "${PREFIX}/home_load/power" -m "${homeload}"
