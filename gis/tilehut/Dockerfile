FROM node:6

RUN apt update; apt install -y git

RUN git clone https://github.com/frederiksberg/tilehut

WORKDIR tilehut

RUN npm install

CMD npm start