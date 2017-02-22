import pytest
from rdflib.plugins.sparql.sparql import Query

from asclepius.queries import (
        _valid_drug,
        all_drugs,
        all_ddis,
        ddi_from_drugs,
    )


def test_valid_drug():
    assert _valid_drug('chebi:123')
    assert _valid_drug('dinto:DB123')
    assert not _valid_drug('dinto:123')
    assert not _valid_drug('chebi:DB123')


def test_all_ddis_compiles():
    assert type(all_ddis()) == Query


def test_all_drugs_compiles():
    assert type(all_drugs()) == Query


def test_ddi_from_drugs_compiles_with_correct_drug_identifiers():
    assert type(ddi_from_drugs(['dinto:DB123', 'chebi:123'])) == Query


def test_ddi_from_drugs_raises_with_incorrect_drug_identifiers():
    with pytest.raises(ValueError):
        ddi_from_drugs(['dinto:123', 'chebi:123'])
        ddi_from_drugs(['garbage', 'rubbish'])
