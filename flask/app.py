from flask import Flask, request
from postgrest import metadata, to_geojson

app = Flask(__name__)

@app.route("/v1/meta", methods=["GET"])
def table():

    res = metadata()

    return res, 200, {"ContentType": "application/json"}


@app.route("/v1/meta/<table>", methods=["GET"])
def table(table):
    srid = request.args.get("srid", default=4326, type=int)
    where = request.args.get("where", default=None, type=str)

    res = to_geojson(table, srid, where)

    return res, 200, {"ContentType": "application/json"}

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')