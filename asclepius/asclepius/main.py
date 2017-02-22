from flask import Flask, jsonify, request
from dinto import dinto

app = Flask(__name__)


class InvalidUsage(Exception):
    status_code = 400

    def __init__(self, message, status_code=None, payload=None):
        Exception.__init__(self)
        self.message = message
        if status_code is not None:
            self.status_code = status_code
        self.payload = payload

    def to_dict(self):
        rv = dict(self.payload or ())
        rv['message'] = self.message
        return rv


@app.errorhandler(InvalidUsage)
def handle_invalid_usage(error):
    response = jsonify(error.to_dict())
    response.status_code = error.status_code
    return response


@app.route("/drugs")
def drugs():
    return jsonify([x[0] for x in dinto.all_drugs()])


@app.route("/all_ddis")
def all_ddis():
    return jsonify([x[0] for x in dinto.all_ddis()])


@app.route('/ddis', methods=['POST'])
def ddis():
    params = request.get_json()

    if params is None or 'drugs' not in params or len(params['drugs']) < 2:
        raise InvalidUsage("Expecting {'drugs': [...]} with at least two drugs")

    drugs = params['drugs']

    try:
        dinto_res = dinto.ddi_from_drugs(*drugs)
    except ValueError as e:
        raise InvalidUsage(str(e))

    res = [{'uri': uri, 'label': label} for (uri, label) in dinto_res]

    return jsonify(res)


@app.route("/ping")
def ping():
    return '', 204


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
