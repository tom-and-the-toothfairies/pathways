import pytest

from asclepius.dinto import (
        ddi_from_drugs,
    )


def test_ddi_from_drugs_raises_with_uncachable_things():
    with pytest.raises(ValueError):
        ddi_from_drugs([''])

def test_ddi_from_drugs_raises_with_too_few_args():
    with pytest.raises(ValueError):
        ddi_from_drugs(frozenset(['http://perl.oboelibrary.org/din-toe/chubby:1245']))
