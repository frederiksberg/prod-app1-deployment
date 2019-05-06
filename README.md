# PostgREST til åbne data API

Til at udstille data udenfor firewallen bruges [PostgREST](http://postgrest.org/en/latest/). Data sendes fra den interne server til en PostgreSQL database skyen. Dette kan  

## Opsætning

### PostgREST
Kommer

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

## Eksempel på kald
Herunder ses eksempel på kald, som bruger `to_geojson` funktionen til at returnerer GeoJSON.
```bash
curl -X POST "http://localhost:3000/rpc/to_geojson" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"srid\": 4326, \"_tbl\": \"soe\", \"geom_column\": \"geom\"}"
```

