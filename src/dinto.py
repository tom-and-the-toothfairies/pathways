import queries
import rdflib
import os

__all__ = ['dinto']

ONTOLOGY_FILE = (os.environ.get('ASCLEPIUS_ONTOLOGY_FILE') or
                 "../DINTO/DINTO 1/DINTO_1.owl")

class Dinto():
    def __init__(self, owl_filepath=ONTOLOGY_FILE):
        self.graph = rdflib.Graph()
        self.graph.load(owl_filepath)

    @property
    def all_drugs(self):
        res = self.graph.query(queries.all_drugs)
        return [x[0].toPython() for x in res]

    @property
    def all_ddis(self):
        res = self.graph.query(queries.all_ddis)
        return [x[0].toPython() for x in res]


dinto = Dinto()
