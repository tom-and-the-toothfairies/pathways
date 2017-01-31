import clize
import owlready

def main(dinto_file):
    """Perform pathway analysis given some Drug Interaction Ontology.

    dinto_file: path to DINTO ontology OWL file

    """

    onto = owlready.get_ontology(dinto_file)
    onto.load()


if __name__ == '__main__':
    clize.run(main)

