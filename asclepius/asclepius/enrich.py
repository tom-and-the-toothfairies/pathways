from hashlib import sha1
import csv
import sys
import dinto
import clize
from clize.parameters import one_of

def _sha_int(string):
    return int(sha1(string.encode()).hexdigest()[-8:], 16)

def _enrich(ddi):
    uri = ddi['uri']
    result = {
        'harmful': bool(_sha_int(uri) % 2),
        'spacing': _sha_int(uri) % 14 + 1,

        # we want them to be a bit different
        'agonism': bool(_sha_int(''.join(sorted(uri))) % 2),
    }

    result.update(ddi)
    return result

def enrich(ddis):
    return [_enrich(ddi) for ddi in ddis]


def main(flavour:one_of('harmful', 'agonism')):
    fieldnames = ('drug_a', 'drug_b', flavour, 'time', 'unit')

    writer = csv.DictWriter(sys.stdout, fieldnames=fieldnames)
    writer.writeheader()

    for ddi in enrich(dinto.all_ddis()):
        ddi.update({'time': ddi['spacing'], 'unit': 'hr'})
        writer.writerow({k: ddi[k] for k in fieldnames})


if __name__ == '__main__':
    clize.run(main)
