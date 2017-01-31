import clize
import rdflib
import logging
from itertools import islice


def load_from_file(dinto_file):
    """
    return a loaded Graph() object from the given `dinto_file`
    """
    g = rdflib.Graph()
    logging.info('Created graph')
    g.load(dinto_file)
    logging.info('Finished Loading {}'.format(dinto_file))
    return g


def main(dinto_file):
    """Perform pathway analysis given some Drug Interaction Ontology.

    dinto_file: path to DINTO ontology OWL file

    """
    g = load_from_file(dinto_file)
    for s, p, o in islice(g, 10):
        print(f'Subject: {s}')
        print(f'Predicate: {p}')
        print(f'Object: {o}')


if __name__ == '__main__':
    clize.run(main)
