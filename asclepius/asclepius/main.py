import socket
import requests
import logging
logging.basicConfig(level=logging.INFO)

from flask import Flask, jsonify, request

import dinto


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


@app.route("/all_drugs", methods=['GET'])
def drugs():
    """Return a list of all drugs listed in DINTO"""
    return jsonify(dinto.all_drugs())


@app.route("/all_ddis", methods=['GET'])
def all_ddis():
    """Return a list of all drug-drug interactions listed identified in DINTO"""
    return jsonify(dinto.all_ddis())


@app.route('/ddis', methods=['POST'])
def ddis():
    """Return all of the Drug-Drug interactions involving the given list of (at least 2) drugs

    post parameters:
      drugs: [<drug_a>, <drug_b>, ... ]]

    Drugs are identified as either 'dinto:DB123' or 'chebi:123'"""

    params = request.get_json()

    if params is None or 'drugs' not in params or len(params['drugs']) < 2:
        raise InvalidUsage("Expecting {'drugs': [...]} with at least two drugs")

    drugs = params['drugs']

    try:
        dinto_res = dinto.ddi_from_drugs(frozenset(drugs))
    except ValueError as e:
        raise InvalidUsage(str(e))

    return jsonify(dinto_res)

if __name__ == '__main__':
    logging.info('Finished')
    app.run(debug=False, host='0.0.0.0')
