# PostgREST til åbne data API
![Swagger](https://user-images.githubusercontent.com/7534153/57377665-4a336180-71a3-11e9-8491-685008318867.PNG)

Til at udstille data udenfor firewallen bruges [PostgREST](http://postgrest.org/en/latest/). Data sendes fra den interne server til en PostgreSQL database skyen. Dette kan gøres med script, som køres som et job - se eksempel [her](https://github.com/frederiksberg/automation-scripts/blob/master/Python/api/transfer_tables.py). 

For at øge brugervenlighed for geodata så de f.eks. kan læses direkte ind i QGIS med GET-request er der lavet en wrapper i [Flask](http://flask.pocoo.org/docs/1.0/api/) som kalder PostgREST. 

## Opsætning
Herunder kommer gennemgang af opsætning af PostgREST og Swagger vha. docker-compose samt funktioner til PostgreSQL til at returnerer GeoJSON.

Klon git-repository og tilret `docker-compose.yml` og kør `docker-compose up`


### PostgREST
Som indledning kan denne  [tutorial](http://postgrest.org/en/latest/tutorials/tut0.html) anbefales. 

Hvis PostgREST kører i docker på samme server som databasen og hvis denne er en del at et docker network, kan følgende kommando bruges til at forbinde PostgREST containeren til netværket. Herved kan `<HOST>` `PGRST_DB_URI` i  `docker-compose.yml` sættes til PostgreSQL container navn.  

`docker network connect <NETWORK> <CONTAINER>`



#### Opdater Caching
Følgende kan tilføjes til crontab på serveren, så PostgREST cashing bliver opdateret ([kilde](http://postgrest.org/en/latest/admin.html#schema-reloading))

`0 * * * * docker restart <CONTAINER>`

### PostgreSQL 
For at kunne udstille data i GeoJSON format gennem PostgREST bruges to funktioner som kræver at PostGIS er installeret. Den første laver rækker om til GeoJSON `features`. Den anden laver features om til `FeatureCollection`

#### Featues
Function som laver hver række i en tabel om til en GeoJSON feature ([kilde](http://blog.cleverelephant.ca/2019/03/geojson.html)). 
```sql
CREATE OR REPLACE FUNCTION public.rowjsonb_to_geojson_srid(rowjsonb jsonb, geom_column text DEFAULT 'geom'::text, srid integer DEFAULT 4326)
 RETURNS text
 LANGUAGE plpgsql
 IMMUTABLE STRICT
AS $function$
DECLARE 
 json_props jsonb;
 json_geom jsonb;
 json_type jsonb;
BEGIN
 IF NOT rowjsonb ? geom_column THEN
   RAISE EXCEPTION 'geometry column ''%'' is missing', geom_column;
 END IF;
 json_geom := ST_AsGeoJSON(st_transform((rowjsonb ->> geom_column)::geometry, srid))::jsonb;
 json_geom := jsonb_build_object('geometry', json_geom);
 json_props := jsonb_build_object('properties', rowjsonb - geom_column);
 json_type := jsonb_build_object('type', 'Feature');
 return (json_type || json_geom || json_props)::text;
END; 
$function$
;
```

#### FeatureCollection
For at få PostgREST til at udstille  GeoJSON bruges nedensående funktion, som afhænger af ovenstående `rowjsonb_to_geojson_srid()` og sørger formatering.

```sql
CREATE OR REPLACE FUNCTION api.to_geojson(_tbl regclass, geom_column text DEFAULT 'geom'::text, srid integer DEFAULT 4326)
 RETURNS TABLE(type text, features jsonb)
 LANGUAGE plpgsql
AS $function$
BEGIN
   RETURN QUERY EXECUTE format(
   	E'
	select
	    \'FeatureCollection\' as "type",
		jsonb_agg(features.feature::json) as "features"
	FROM (
		SELECT api.rowjsonb_to_geojson_srid(to_jsonb(a.*), \'%2$s\', %3$s) feature FROM %1$s a) as features;
	', _tbl, geom_column, srid);
END
$function$
;
```
PostgREST ustiller som udgangspunkt data som en liste med objekter. Når `to_geojson` kaldes returnes kun et enkelt GeoJSON object i listen. Det er muligt udelukkende få returneret objektet ved at sender headeren: 

`Accept: application/vnd.pgrst.object+json`

 ([kilde](http://postgrest.org/en/latest/api.html?highlight=list%20of%20objects#singular-or-plural))

## API wrapper
For at forsimple kald til geodata er der lavet en API wrapper i Flask, så man bliver fri for at lave POST-requests når der skal laves GeoJSON. Der understøttes også parameter i URL'en, men indtil videre er det kun muligheden for at sætte projektionen vha. SRID.

### Swagger
PostgREST autogenererer OpenAPI beskrivelse som Swagger UI indlæser og bygger siden op efter. Denne bliver modificeret i Flask således and den er tilpasset de ændringer Flask API'et laver ifht. routing og parameter. Derudover ændres også generel information om siden. OpenAPI beskrivelsen ligger under `/v1/meta`

## Eksempel på kald

### Flask
Herunder ses eksempel på kald til API wrapper, som forsimpler kaldet efter GeoJSON.
```bash
curl "http://localhost:5000/v1/data/<TABLE>?srid=<SRID>"
# Eks
curl "http://104.248.90.41:5000/v1/data/soe?srid=25832"
```

### PostgREST
Herunder ses eksempel på kald, som bruger `to_geojson` funktionen til at returnerer GeoJSON.
```bash
curl -X POST "http://localhost:3000/rpc/to_geojson" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"srid\": 4326, \"_tbl\": \"YOURTABLE\", \"geom_column\": \"GEOM_COLUMN\"}"
```

