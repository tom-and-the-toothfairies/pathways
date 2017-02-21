from flask import Flask, jsonify
from dinto import dinto
app = Flask(__name__)


@app.route("/drugs")
def drugs():
    return jsonify(dinto.all_drugs)


@app.route("/ddis")
def ddis():
    return jsonify(dinto.all_ddis)


@app.route("/ping")
def ping():
    return '', 204

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
