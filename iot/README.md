**REDO THIS**

# IoT tools

This repository contains a skeleton setting up the [Node-RED](https://nodered.org) and [Grafana](https://grafana.com)
project using [docker-compose](https://docs.docker.com/compose/).

**Note:** Please use this `docker-compose.yml` file as a starting point for testing
but keep in mind that for production usage it might need modifications. 

## Directory layout

* `docker-compose.yml`: the docker-compose file containing the services

## Persistent storage
Docker volumes are used for persistent storage of data from the different apps and are defined in `docker-compose.yml`

* `grafana-data`: volume containing the Grafana data
* `nodered-data`: volume containing the Node-RED data


## Configuration

### Grafana
#### ENV
Edit `.env` file with password and plugins ([ref](https://grafana.com/docs/installation/docker/#installing-plugins-for-grafana)). Here's available plugins: https://grafana.com/plugins

#### SMTP
Der kan opættes SMTP så Grafana kan sende mail med alerts. Dette gøres ved at rette `/etc/grafana/grafana.ini` som også er beskrevet [her](https://grafana.com/docs/installation/configuration/#smtp). Ret filen i en kørende containeren ved at:
* `docker exec -u 0 -it grafana bash` (Der logges ind som root med `-u 0`)
* `vi /etc/grafana/grafana.ini` (vim/nano er ikke installeret som default, så skal gøres første gang der skal rettes)
* Tilret `smtp` konfigurationen (Se eksempel herunder)

```ini
[smtp]
enabled = true
host = smtp.gmail.com:465
user = YOUR_MAIL
# If the password contains # or ; you have to wrap it with triple quotes. Ex """#password;"""
password = YOUR_PW
cert_file =
key_file =
skip_verify = false
from_address = admin@grafana.localhost
from_name = Grafana
ehlo_identity =

[emails]
welcome_email_on_sign_up = false
templates_pattern = emails/*.html
```
Der kan bruges google mail konto, hvor der med fordel kan laves App password som grafana bruger. 

## Requirements

Before using this `docker-compose.yml` file, make sure you have [Docker](https://www.docker.com/community-edition)
installed.

## Security
* Grafana `admin` user: `.env`
* Node-RED [enable admin auth](https://nodered.org/docs/security): `data/nodered/settings.js` (Currently needs to be done after `docker-compose up` and entails `docker restart nodered`)

## Usage

When configuration and security steps are done start all the IoT stack components by simply running:

```bash
$ docker-compose up
```

After all the components have been initialized and started, you should be able
http://localhost:3000/ (Grafana) and http://localhost:1880/ (Node-RED) in your browser.

## Getting started

### First timeseries table in PostgreSQL
TimescaleDB is used to handle large reading and writing of data and is supported when querying data from Grafana
```sql
CREATE TABLE water_level (
	ts timestamptz NOT null,
	pressure float NOT NULL,
	temperature float NOT NULL,
	battery float NOT NULL,
	device_id int4 NULL
);

-- Create the hypertable
SELECT create_hypertable('water_level', 'ts');
```

### First flow in Node-RED
We will create a flow which takes device data from Lora server and writes the data to table in PostgreSQL. In order to read and write data to PostgreSQL, we can make use of the [node-red-contrib-postgres](https://flows.nodered.org/node/node-red-contrib-postgres) nodes, which can be installed under Manage palette in the top left menu. From here we need to:
1. Get data from Lora server.
* Make sure to register a new HTTP integration for the Application on Lora server and point the Uplink data url to `http://nodered:1880/<nodered-http-endpoint>`
2. Prepare data for table insert in postgres.
3. Write the data to the database.

You can simply refer to `db.frb-data.dk` as the host when setting up the connection details in the postgres node.

Here's a bit of flow inspiration, which can easily be imported to yout Node-RED in the top left menu:
```json
[{"id":"a7bcd21.0d4a33","type":"http in","z":"1914bc60.4cc104","name":"","url":"/iot/gps","method":"post","upload":false,"swaggerDoc":"","x":110,"y":60,"wires":[["880cbd3e.d8045","32d5646a.05929c"]]},{"id":"23f16f1d.91b9f","type":"template","z":"1914bc60.4cc104","name":"format query","field":"payload","fieldType":"msg","format":"handlebars","syntax":"mustache","template":"insert into gps(time, latitude, longitude, altitude, temperature, battery) \nvalues (to_timestamp($time/1000.0), $latitude, $longitude, $altitude, $temperature, $battery)","x":490,"y":60,"wires":[["da29f2e3.cec04","590fc4ed.76e5cc"]]},{"id":"880cbd3e.d8045","type":"function","z":"1914bc60.4cc104","name":"setup params","func":"var data = msg.payload.object\n\n\nmsg.queryParameters = msg.queryParameters || {};\nmsg.queryParameters.time = data.timestamp;\nmsg.queryParameters.latitude = data.latitude;\nmsg.queryParameters.longitude = data.longitude;\nmsg.queryParameters.altitude = data.altitude; \nmsg.queryParameters.temperature = data.temperature;    \nmsg.queryParameters.battery = data.battery;\n\n\n\n\nreturn msg;","outputs":1,"noerr":0,"x":300,"y":60,"wires":[["23f16f1d.91b9f"]]},{"id":"da29f2e3.cec04","type":"postgres","z":"1914bc60.4cc104","postgresdb":"17235061.c3afa","name":"iot db","output":false,"outputs":0,"x":650,"y":60,"wires":[]},{"id":"590fc4ed.76e5cc","type":"debug","z":"1914bc60.4cc104","name":"","active":false,"tosidebar":true,"console":false,"tostatus":false,"complete":"payload","x":670,"y":100,"wires":[]},{"id":"32d5646a.05929c","type":"http response","z":"1914bc60.4cc104","name":"","statusCode":"200","headers":{},"x":280,"y":100,"wires":[]},{"id":"17235061.c3afa","type":"postgresdb","z":"","hostname":"postgresql","port":"5432","db":"iot","ssl":false}]
```

### First dashboard in Grafana
1. Add PostgreSQL datasource. Hostname is `db.frb-data.dk` and it is reommendeed to use the `grafanareader` read only user.
2. Create a new dashboard and add a Graph panel.
3. Edit panel and make sure `grafanareader` has privileges to read from the  table.
4. Under `Metrics` pane it is possible to query the table using a Query Builder or plain SQL. Grafana needs time and metric column in order to generate the gragh.

## References
* [TimescaleDB](https://docs.timescale.com/v1.2/main)
* [Node-RED](https://nodered.org/docs/)
* [Grafana](http://docs.grafana.org/)

