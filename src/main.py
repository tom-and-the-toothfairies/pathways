import clize
import rdflib
import logging


def main(dinto_file):
    """Perform pathway analysis given some Drug Interaction Ontology.

    dinto_file: path to DINTO ontology OWL file

    """
    g = rdflib.Graph()
    logging.info('Created graph')
    g.load(dinto_file)
    logging.info('Finished Loading {}'.format(dinto_file))

if __name__ == '__main__':
    clize.run(main)

