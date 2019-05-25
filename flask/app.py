from flask import Flask, request
from postgrest import to_geojson

app = Flask(__name__)

@app.route("/<table>", methods=["GET"])
def table(table):
    srid = request.args.get("srid", default=4326, type=int)
    where = request.args.get("where", default=None, type=str)

    res = to_geojson(table, srid, where)

    return res, 200, {"ContentType": "application/json"}
