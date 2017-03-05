import re

__all__ = ['all_drugs', 'all_ddis', 'ddi_from_drugs']

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

def all_drugs():
    q = f'''
    {PREFIXES}
    SELECT ?drug ?label
    WHERE {{
        ?drug rdfs:subClassOf {PHARMACOLOGICAL_ENTITY}.
        ?drug rdfs:label ?label
    }}
    '''
    return q

def all_ddis():
    q = f'''
    {PREFIXES}
    SELECT ?interaction ?label
    WHERE {{
        ?interaction rdfs:subClassOf {DDI}.
        ?interaction rdfs:label ?label
    }}
    '''
    return q


def _valid_drug(drug_identifier):
  pattern = re.compile('(dinto:DB)|(chebi:)\d+')
  return pattern.match(drug_identifier) is not None

def ddi_from_drugs(drugs):
    if len(drugs) < 2:
        raise ValueError("Need at least 2 drugs to find interactions")

    if not all(_valid_drug(drug) for drug in drugs):
        raise ValueError("Drugs must be specified as chebi:123 or dinto:DB123")


    drug_search_space = ', '.join(drugs)

    q = f'''
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
    return q
