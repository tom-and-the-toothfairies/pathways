import re
import requests
import logging
from functools import lru_cache

from app import app

__all__ = ['all_drugs', 'all_ddis', 'ddi_from_drugs']

SPARQL_ADDRESS = app.config['FUSEKI_ADDRESS']
SPARQL_ENDPOINT = f'http://{SPARQL_ADDRESS}/dinto/query'

logging.info(f"Using Fuseki server at {SPARQL_ADDRESS}")

DRUG_PATTERN = re.compile('(dinto:DB)|(chebi:)\d+')

DINTO_PREFIX = 'http://purl.obolibrary.org/obo/DINTO_'
CHEBI_PREFIX = 'http://purl.obolibrary.org/obo/CHEBI_'

PREFIXES = f'''
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX dinto: <{DINTO_PREFIX}>
PREFIX chebi: <{CHEBI_PREFIX}>
'''

PHARMACOLOGICAL_ENTITY = 'dinto:000055'
DDI = 'dinto:00010'


def sparql(qfunction):
    """
    Cause a function which returns a sparql query to actually run that query.
    Assumes that the arguments that the qfunction takes are all hashabled, to
    make use of the handy-dandy lru cache transparently
    """

    def _do_sparql(query):
        payload = {'query': query}
        response = requests.post(SPARQL_ENDPOINT, data=payload)

        if response.status_code != 200:
            response.raise_for_status()
        else:
            result = response.json()

        return [{v: entry[v]['value'] for v in result['head']['vars']}
                for entry in result['results']['bindings']]

    @lru_cache()
    def sparqled(*args, **kwargs):
        query = qfunction(*args, **kwargs)
        return _do_sparql(query)

    return sparqled


@lru_cache()
@sparql
def drugs(labels=None):

    if labels is not None:
        if not isinstance(labels, frozenset):
            raise ValueError("for cachability, `labels` must be given as a frozenset")
        label_str_literals = [f'"{label}"' for label in labels]
        filter = f'FILTER (?label in ({", ".join(label_str_literals)}))'
    else:
        filter = ''

    return f'''
    {PREFIXES}
    SELECT ?uri ?label
    WHERE {{
        ?uri rdfs:subClassOf {PHARMACOLOGICAL_ENTITY} .
        ?uri rdfs:label ?label
        {filter}
    }}
    '''


@sparql
def all_ddis():
    return f'''
    {PREFIXES}
    SELECT ?uri ?label
    WHERE {{
        ?uri rdfs:subClassOf {DDI}.
        ?uri rdfs:label ?label
    }}
    '''

def _valid_drug(drug_identifier):
    return DRUG_PATTERN.match(drug_identifier) is not None


@sparql
def ddi_from_drugs(drugs):
    if not isinstance(drugs, frozenset):
        raise ValueError("for cachability, `drugs` must be given as a frozenset")

    if len(drugs) < 2:
        raise ValueError("Need at least 2 drugs to find interactions")

    if not all(_valid_drug(drug) for drug in drugs):
        raise ValueError("Drugs must be specified as chebi:123 or dinto:DB123")

    drug_search_space = ', '.join(drugs)

    return f'''
    {PREFIXES}
    SELECT ?drug_a ?drug_b ?uri ?label
    WHERE {{
        ?uri rdfs:label ?label.
        ?uri rdfs:subClassOf {DDI} .
        ?uri owl:equivalentClass ?equivalance .
        ?equivalance owl:intersectionOf ?restrictions .
        ?restrictions rdf:first ?drug1Restriction .
        ?restrictions rdf:rest  ?tail .
        ?tail rdf:first ?drug2Restriction .
        ?drug1Restriction owl:someValuesFrom ?drug_a .
        ?drug2Restriction owl:someValuesFrom ?drug_b .
        FILTER (?drug_a in ({drug_search_space}) &&
                ?drug_b in ({drug_search_space})    )
    }}'''
