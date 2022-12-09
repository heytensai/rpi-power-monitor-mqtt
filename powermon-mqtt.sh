#!/bin/bash

[ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -en "$0" "$0" "$@" || :

HOST="" #ip address of your MQTT broker, if using HA its the same IP as
PREFIX="" #group name for sensors i.e. home, garage, shop, etc

# if your MQTT broker requires authentication, or leave blank
MQTT_UN="" #example, MQTT Mosquitto for HA is homeassistant
MQTT_PW="" #example, for MQQT Mosquitto for HA found Settings>Devices & Services>Mosquitto Broker Configure>MQTT settings>Password

for ct in $(seq 1 6) #for v0.1.0, use (seq 0 5)
do
	w=$(influx -database power_monitor -execute "select mean(power) from raw_cts where ct = '${ct}' and time > now() - 1m group by power fill(0) limit 1" -format csv |grep ^raw_cts |perl -lpe 's/.*,//; s/(\..).*/$1/; $_=0 if ($_<0);')
	mosquitto_pub -u "${MQTT_UN}" -P "${MQTT_PW}" -h "${1}" -t "${PREFIX}/ct_${ct}/power" -m "${w}"
done

homeload=$(influx -database power_monitor -execute "select mean(power) from home_load where time > now() - 1m group by power fill(0) limit 1" -format csv |grep ^home_load |perl -lpe 's/.*,//; s/(\..).*/$1/')
mosquitto_pub -u "${MQTT_UN}" -P "${MQTT_PW}" -h "${HOST}" -t "${PREFIX}/home_load/power" -m "${homeload}"
