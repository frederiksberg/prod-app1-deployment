from flask import Flask, request
from flask_cors import CORS
from postgrest import metadata, to_geojson

app = Flask(__name__)
CORS(app)

@app.route("/meta", methods=["GET"])
def meta():

    res = metadata()

    return res, 200, {"ContentType": "application/json"}


@app.route("/data/<table>", methods=["GET"])
def table(table):
    srid = request.args.get("srid", default=4326, type=int)
    where = request.args.get("where", default=None, type=str)

    res = to_geojson(table, srid, where)

    return res, 200, {"ContentType": "application/json"}

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
