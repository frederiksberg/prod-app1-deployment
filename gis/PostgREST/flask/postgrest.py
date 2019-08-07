import requests
import json

def metadata():
    """
    Manipulating OpenAPI definition from PostgREST
    """
    url = "http://postgrest:3000"
    r = requests.get(url)

    meta = r.json()

    # Remove /rpc/ and only keep GET
    paths = {o_k: {i_k:i_v for (i_k, i_v) in o_v.items() if i_k == 'get'} for (o_k, o_v) in meta['paths'].items() if o_k[:5] != '/rpc/'}
    # Only srid parameter
    for k,v in paths.items():
        if k != '/':
            paths[k]['get']['parameters'] = [{ "$ref": "#/parameters/srid" }]

    # Update meta file
    meta['paths'] = paths

    meta['parameters'] = {
        "srid" : {
            "name": "srid",
            "required": False,
            "in": "query",
            "type": "integer"
        }
    }

    # Chanage info
    meta['info'] = {
        "version": "v1",
        "title": "Frederiksberg Kommunes API",
        "description": "Denne side en automatisk genereret af PostgREST og efterfølgende tilrettet"
    }

    return json.dumps(meta)

def to_geojson(table, srid=4326, where=None):
    url = "http://postgrest:3000/rpc/to_geojson"
    data = {
        "srid": srid,
        "_tbl": table,
        "geom_column": "geom"
    }
    headers = {'Accept': 'application/vnd.pgrst.object+json'}
    r = requests.post(url, data=data, headers=headers)

    return r.text
