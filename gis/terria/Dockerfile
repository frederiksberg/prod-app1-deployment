FROM node:8

RUN apt-get update && apt-get install -y gdal-bin git

RUN mkdir -p /usr/src/app && mkdir -p /etc/config/client

ADD https://api.github.com/repos/TerriaJS/TerriaMap/git/refs/heads/master /opt/version.json
RUN git clone https://github.com/TerriaJS/TerriaMap /usr/src/app

WORKDIR /usr/src/app

RUN npm install
RUN npm run gulp --max-old-space-size=4096

RUN rm wwwroot/config.json && ln -s /etc/config/client/config.json wwwroot/config.json

CMD ["node", "./node_modules/terriajs-server/lib/app.js", "--config-file", "devserverconfig.json"]
# CMD ["npm start"]
