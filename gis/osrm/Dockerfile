FROM osrm/osrm-backend:latest

RUN apt-get update && apt-get -y --no-install-recommends install wget

RUN mkdir /opt/data

COPY ./entrypoint.sh /opt

RUN chmod +x /opt/entrypoint.sh

CMD ["/opt/entrypoint.sh"]
