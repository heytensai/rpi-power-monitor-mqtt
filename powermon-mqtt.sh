#!/bin/bash

[ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -en "$0" "$0" "$@" || :

HOST="${1}"
PREFIX="${2}"
if [ "${PREFIX}" = "" ]
then
	PREFIX="powermon"
fi

# if your MQTT broker requires authentication, or leave blank
MQTT_UN=""
MQTT_PW=""

for ct in $(seq 0 5)
do
	w=$(influx -database power_monitor -execute "select mean(power) from raw_cts where ct = '${ct}' and time > now() - 1m group by power fill(0) limit 1" -format csv |grep ^raw_cts |perl -lpe 's/.*,//; s/(\..).*/$1/; $_=0 if ($_<0);')
	mosquitto_pub -u "${MQTT_UN}" -P "${MQTT_PW}" -h "${HOST}" -t "${PREFIX}/ct_${ct}/power" -m "${w}"
done

homeload=$(influx -database power_monitor -execute "select mean(power) from home_load where time > now() - 1m group by power fill(0) limit 1" -format csv |grep ^home_load |perl -lpe 's/.*,//; s/(\..).*/$1/')
mosquitto_pub -u "${MQTT_UN}" -P "${MQTT_PW}" -h "${HOST}" -t "${PREFIX}/home_load/power" -m "${homeload}"
