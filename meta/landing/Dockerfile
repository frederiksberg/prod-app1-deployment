FROM nginx:alpine

WORKDIR /usr/src

RUN apk add --no-cache --virtual .build-deps nodejs nodejs-npm git

RUN git clone https://github.com/frederiksberg/frb-data-landing .

RUN npm install
RUN npm run build

RUN cp -r /usr/src/build/* /usr/share/nginx/html/

RUN rm -rf /usr/src/*

RUN apk --purge del .build-deps