FROM node:6

RUN apt update; apt install -y git

ADD https://api.github.com/repos/frederiksberg/tilehut/git/refs/heads/master /opt/version.json
RUN git clone https://github.com/frederiksberg/tilehut /opt/tilehut

WORKDIR /opt/:xtilehut

RUN npm install

CMD npm start
