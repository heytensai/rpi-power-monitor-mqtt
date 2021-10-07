# rpi-power-monitor-mqtt
Publish data from rpi-power-monitor to MQTT

Building on the amazing work at https://github.com/David00/rpi-power-monitor/wiki, this script will export data from influx and send it to an MQTT server. My specific use case for this is to bring the data into [Home Assistant](https://www.home-assistant.io/), but this could certainly used for many other purposes.

## Prerequisites

You'll need to install the InfluxDB and Mosquitto clients that the script uses.


```
apt-get install influxdb-clients
apt-get install mosquitto-clients
```

Example cron tab:

```
* * * * * /home/pi/powermon-mqtt.sh [mqtt-server] [mqtt-prefix]
```

This can be added to Home Assistant as an MQTT sensor, such as:

```
- platform: mqtt
  name: "Powermon CT 0"
  state_topic: "powermon/ct_0/power"
  icon: mdi:electron-framework
  unit_of_measurement: 'W'
```
