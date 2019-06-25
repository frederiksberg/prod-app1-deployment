create database iot;
create database api;
create database vectortile;

set database iot;
create extension postgis;
create extension timescaledb;

set database api;
create extension postgis;

set database vectortile;
create extension postgis;

--USERS
CREATE USER vectortile WITH PASSWORD 'mypw';
GRANT ALL PRIVILEGES ON DATABASE vectortile to vectortile;

CREATE USER iot WITH PASSWORD 'mypw';
GRANT ALL PRIVILEGES ON DATABASE iot to iot;

CREATE USER api WITH PASSWORD 'mypw';
GRANT ALL PRIVILEGES ON DATABASE api to api;

--PostgREST
create role postgrest_authenticator noinherit login password 'secret';
create role postgrest_web_anon nologin;

GRANT CONNECT ON DATABASE api TO postgrest_web_anon;

--giv adgang til api schemaet
grant usage on schema api to postgrest_web_anon;

--Brugeren får lov til at læse (select) fra alle tabellerne i schemaerne
	GRANT SELECT ON ALL TABLES IN SCHEMA api 
	  TO postgrest_web_anon;

--Hvis der i fremtiden oprettes nye tabeller i schemaerne har brugeren også adgang til dem
ALTER DEFAULT PRIVILEGES IN SCHEMA api
  GRANT SELECT ON TABLES TO postgrest_web_anon;
  
grant postgrest_web_anon to postgrest_authenticator;
grant postgrest_web_anon to api;

