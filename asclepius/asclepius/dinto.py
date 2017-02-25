import functools
import logging
import os

import rdflib

import queries
from utils import timing

__all__ = ['dinto']

ONTOLOGY_FILE = os.getenv('ASCLEPIUS_ONTOLOGY_FILE', 'DINTO/DINTO 1/DINTO_1.owl')


class Dinto():
    def __init__(self, owl_filepath=ONTOLOGY_FILE):
        self.graph = rdflib.Graph()

        with timing(f"loading ontology from {owl_filepath}"):
            self.graph.load(owl_filepath)

    def _listify(self, query_result):
        return [[y.toPython() for y in x] for x in query_result]

    @functools.lru_cache()
    def all_drugs(self):
        with timing(f"querying DINTO for all drugs"):
            res = self.graph.query(queries.all_drugs())

        return self._listify(res)

    def all_ddis(self):
        with timing(f"querying DINTO for all DDIs"):
            res = self.graph.query(queries.all_ddis())

        return self._listify(res)

    @functools.lru_cache()
    def ddi_from_drugs(self, drugs):
        with timing(f"querying DINTO for drugs: {repr(drugs)}"):
            res = self.graph.query(queries.ddi_from_drugs(drugs))

        return self._listify(res)


dinto = Dinto()
