from asclepius.queries import (
        _valid_drug,
        all_drugs,
        all_ddis,
        ddi_from_drugs,
    )

from rdflib.plugins.sparql.sparql import Query

def test_valid_drug():
    assert _valid_drug('chebi:123')
    assert _valid_drug('dinto:DB123')
    assert not _valid_drug('dinto:123')
    assert not _valid_drug('chebi:DB123')


def test_they_all_compile():
    assert type(all_ddis()) == Query
    assert type(all_drugs()) == Query
    assert type(ddi_from_drugs('dinto:DB123', 'chebi:123')) == Query
