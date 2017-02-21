__all__ = ['all_drugs', 'all_ddis']

_PREFIXES = '''
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX obo: <http://purl.obolibrary.org#>
PREFIX dinto: <http://purl.obolibrary.org/obo/DINTO_>
'''

_all_drugs = '''
SELECT ?l
WHERE {
    ?drug rdfs:subClassOf dinto:000055 .
    ?drug rdfs:label ?l
}
'''

_all_ddis = '''
SELECT ?l
WHERE {
    ?interaction rdfs:subClassOf dinto:00010 .
    ?interaction rdfs:label ?l
}
'''

all_drugs, all_ddis = (_PREFIXES + graph for graph in (_all_drugs, _all_ddis))
