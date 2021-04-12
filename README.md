# rpi-power-monitor-mqtt
Publish data from rpi-power-monitor to MQTT

Building on the amazing work at https://github.com/David00/rpi-power-monitor/wiki, this script will export data from influx and send it to an MQTT server. My specific use case for this is to bring the data into [Home Assistant](https://www.home-assistant.io/), but this could certainly used for many other purposes.

Example cron tab:

```
* * * * * /home/pi/powermon-mqtt.sh [mqtt-server] [mqtt-prefix]
```
