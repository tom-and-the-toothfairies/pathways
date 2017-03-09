import pytest

from asclepius.dinto import (
    ddi_from_drugs,
    drugs
)


def test_ddi_from_drugs_raises_with_uncachable_things():
    with pytest.raises(TypeError):
        ddi_from_drugs([''])

def test_ddi_from_drugs_raises_with_too_few_drugs():
    with pytest.raises(ValueError):
        ddi_from_drugs(frozenset(['http://perl.oboelibrary.org/din-toe/chubby:1245']))

def test_ddi_from_drugs_raises_with_non_iterable():
    with pytest.raises(TypeError):
        ddi_from_drugs(object())

def test_drugs_raises_with_non_iterable():
    with pytest.raises(TypeError):
        drugs(object())
