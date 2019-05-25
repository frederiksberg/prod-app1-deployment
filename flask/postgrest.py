import requests

def to_geojson(table, srid=4326, where=None):
    url = "http://104.248.90.41:3030/rpc/to_geojson"
    data = {
        "srid": srid,
        "_tbl": table,
        "geom_column": "geom"
    }
    headers = {'Accept': 'application/vnd.pgrst.object+json'}
    r = requests.post(url, data=data, headers=headers)

    return r.text
