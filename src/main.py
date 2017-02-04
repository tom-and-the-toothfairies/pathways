import clize
import rdflib
import logging
import os


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
    """Count the number of triples in the given ontology

    dinto_file: path to DINTO ontology OWL file

    """
    g = load_from_file(dinto_file)

    print("Ontology {} contains {} triples"
          .format(os.path.basename(dinto_file), len(g)))


if __name__ == '__main__':
    clize.run(main)
