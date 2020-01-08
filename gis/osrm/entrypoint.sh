#!/bin/bash

# Download and overwrite lastest OSM data
wget -O /opt/data/denmark-latest.osm.pbf http://download.geofabrik.de/europe/denmark-latest.osm.pbf

# Pre-process the extract with the car profile
osrm-extract -p /opt/car.lua /opt/data/denmark-latest.osm.pbf
osrm-partition /opt/data/denmark-latest.osrm
osrm-customize /opt/data/denmark-latest.osrm

# Start osrm service
osrm-routed --algorithm mld /opt/data/denmark-latest.osrm