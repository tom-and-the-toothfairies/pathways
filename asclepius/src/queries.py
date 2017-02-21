from rdflib.plugins.sparql import prepareQuery
import functools
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
    SELECT ?l
    WHERE {{
        ?drug rdfs:subClassOf {PHARMACOLOGICAL_ENTITY}.
        ?drug rdfs:label ?l
    }}
    '''
    return prepareQuery(q)

def all_ddis():
    q = f'''
    {PREFIXES}
    SELECT ?l
    WHERE {{
        ?interaction rdfs:subClassOf {DDI}.
        ?interaction rdfs:label ?l
    }}
    '''
    return prepareQuery(q)


_valid_drug = re.compile('(dinto:DB\d+)|(chebi:\d+)')

def ddi_from_drugs(drug_a, drug_b):
    if not all(_valid_drug.match(arg) is not None
               for arg in (drug_a, drug_b)):
        raise ValueError("Drugs must be specified as chebi:123 or dinto:DB123")

    q = f'''
    {PREFIXES}
    SELECT ?ddi
    WHERE {{
        ?ddi rdfs:label ?label.
        ?ddi rdfs:subClassOf {DDI} .

        ?ddi owl:equivalentClass ?equivalance .
        ?equivalance owl:intersectionOf ?restrictions .

        ?restrictions rdf:first ?drug1Restriction .
        ?restrictions rdf:rest  ?tail .

        ?tail rdf:first ?drug2Restriction

        {{
            ?drug1Restriction owl:someValuesFrom {drug_a} .
            ?drug2Restriction owl:someValuesFrom {drug_b}
        }} UNION {{
            ?drug1Restriction owl:someValuesFrom {drug_b} .
            ?drug2Restriction owl:someValuesFrom {drug_a}
        }}

    }}'''
    return prepareQuery(q)
