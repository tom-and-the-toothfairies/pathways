import queries
import rdflib
import functools
import os

__all__ = ['dinto']

ONTOLOGY_FILE = os.getenv('ASCLEPIUS_ONTOLOGY_FILE', 'DINTO/DINTO 1/DINTO_1.owl')


class Dinto():
    def __init__(self, owl_filepath=ONTOLOGY_FILE):
        self.graph = rdflib.Graph()
        self.graph.load(owl_filepath)

    def _listify(self, query_result):
        return [[y.toPython() for y in x]
                for x in query_result]

    @functools.lru_cache()
    def all_drugs(self):
        res = self.graph.query(queries.all_drugs())
        return self._listify(res)

    @functools.lru_cache()
    def all_ddis(self):
        res = self.graph.query(queries.all_ddis())
        return self._listify(res)

    @functools.lru_cache()
    def ddi_from_drugs(self, *drugs):
        res = self.graph.query(queries.ddi_from_drugs(*drugs))
        return self._listify(res)


dinto = Dinto()
