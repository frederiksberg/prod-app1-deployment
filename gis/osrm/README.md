# OSRM
Containeren henter automatisk seneste version af OSM data fra danmark og klargører "car" profilen, som gør det muligt at ruteberegne for biler. 
Det tager derfor en smule tid før servicen er oppe at køre, da vejgrafen skal beregnes. Klargøringen af datasæt og opstart af servicen sker i [entrypoint.sh](entrypoint.sh)

## Links
* http://project-osrm.org/ 
* http://project-osrm.org/docs/v5.22.0/api/
* https://hub.docker.com/r/osrm/osrm-backend/
