import re
import requests

SPARQL_ENDPOINT = 'http://localhost:3030/dinto/query'

__all__ = ['all_drugs', 'all_ddis', 'ddi_from_drugs']

def _do_sparql(query):
    payload = {'query': query}
    response = requests.post(SPARQL_ENDPOINT, data=payload)

    if response.status_code != 200:
        response.raise_for_status()
    else:
        result = response.json()

    return [{v : entry[v]['value'] for v in result['head']['vars']}
            for entry in result['results']['bindings']]


def sparql(qfunction):
    """Cause a function which returns a sparql query to actually run that query"""
    def sparqled(*args, **kwargs):
        query = qfunction(*args, **kwargs)
        return _do_sparql(query)
    return sparqled



PREFIXES = '''
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX dinto: <http://purl.obolibrary.org/obo/DINTO_>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX chebi: <http://purl.obolibrary.org/obo/CHEBI_>
'''

PHARMACOLOGICAL_ENTITY = 'dinto:000055'
DDI = 'dinto:00010'

@sparql
def all_drugs():
    return f'''
    {PREFIXES}
    SELECT ?drug ?label
    WHERE {{
        ?drug rdfs:subClassOf {PHARMACOLOGICAL_ENTITY}.
        ?drug rdfs:label ?label
    }}
    '''

@sparql
def all_ddis():
    return f'''
    {PREFIXES}
    SELECT ?interaction ?label
    WHERE {{
        ?interaction rdfs:subClassOf {DDI}.
        ?interaction rdfs:label ?label
    }}
    '''

def _valid_drug(drug_identifier):
  pattern = re.compile('(dinto:DB)|(chebi:)\d+')
  return pattern.match(drug_identifier) is not None

@sparql
def ddi_from_drugs(drugs):
    if len(drugs) < 2:
        raise ValueError("Need at least 2 drugs to find interactions")

    if not all(_valid_drug(drug) for drug in drugs):
        raise ValueError("Drugs must be specified as chebi:123 or dinto:DB123")


    drug_search_space = ', '.join(drugs)

    return f'''
    {PREFIXES}
    SELECT ?ddi ?label
    WHERE {{
        ?ddi rdfs:label ?label.
        ?ddi rdfs:subClassOf {DDI} .

        ?ddi owl:equivalentClass ?equivalance .
        ?equivalance owl:intersectionOf ?restrictions .

        ?restrictions rdf:first ?drug1Restriction .
        ?restrictions rdf:rest  ?tail .

        ?tail rdf:first ?drug2Restriction .

        ?drug1Restriction owl:someValuesFrom ?drug_a .
        ?drug2Restriction owl:someValuesFrom ?drug_b .

        FILTER (?drug_a in ({drug_search_space}) &&
                ?drug_b in ({drug_search_space})    )

    }}'''
