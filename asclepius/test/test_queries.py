import pytest
from rdflib.plugins.sparql.sparql import Query

from asclepius.dinto import (
        _valid_drug,
        ddi_from_drugs,
    )


def test_valid_drug():
    assert _valid_drug('chebi:123')
    assert _valid_drug('dinto:DB123')
    assert not _valid_drug('dinto:123')
    assert not _valid_drug('chebi:DB123')


def test_ddi_from_drugs_raises_with_incorrect_drug_identifiers():
    with pytest.raises(ValueError):
        ddi_from_drugs(frozenset([]))
        ddi_from_drugs(['dinto:db123', 'chebi:123'])
        ddi_from_drugs(frozenset(['garbage', 'rubbish']))
