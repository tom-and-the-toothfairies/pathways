from hashlib import sha1
import csv
import sys
import dinto
import clize
import socket
import time
from clize.parameters import one_of

UNITS_INTERVAL = {
    'sec': 60,
    'min': 60,
    'hr': 24,
    'day': 7,
    'week': 52,
    'yr': 5,
}


def _sha_int(string):
    return int(sha1(string.encode()).hexdigest()[-8:], 16)


def _enrich(ddi):
    uri = ddi['uri']
    sha = _sha_int(uri)
    unit = tuple(UNITS_INTERVAL.keys())[sha % len(UNITS_INTERVAL)]
    result = {
        'harmful': bool(sha % 2),
        'spacing': sha % UNITS_INTERVAL[unit] + 1,
        'unit': unit,
        'agonism': bool(_sha_int(''.join(sorted(uri))) % 2),
    }

    result.update(ddi)
    return result


def enrich(ddis):
    return [_enrich(ddi) for ddi in ddis]


def main(flavour: one_of('harmful', 'agonism')):
    fieldnames = ('Drug 1', 'Drug 2', 'DDI Type', 'Time', 'Unit')

    writer = csv.DictWriter(sys.stdout, fieldnames=fieldnames,
                            lineterminator='\n')
    writer.writeheader()

    for ddi in enrich(dinto.all_ddis()):
        ddi['Drug 1'] = ddi['drug_a']
        ddi['Drug 2'] = ddi['drug_b']
        ddi['Time'] = ddi['spacing']
        ddi['Unit'] = ddi['unit']

        if flavour == 'harmful':
            ddi['DDI Type'] = 'bad' if ddi[flavour] else 'good'
        if flavour == 'agonism':
            ddi['DDI Type'] = 'agonism' if ddi[flavour] else 'antagonism'

        writer.writerow({k: ddi[k] for k in fieldnames})


def block_until_chiron():
    goes = 10
    while goes:
        try:
            sock = socket.socket()
            time.sleep(1)
            sock.connect(('chiron', 3030))
        except Exception:
            goes -= 1
            continue
        else:
            return

    sys.exit(1)


if __name__ == '__main__':
    block_until_chiron()
    clize.run(main)
