from functools import lru_cache
from hashlib import sha224


def _sha_int(string):
    return int(sha224(string.encode()).hexdigest()[-8:], 16)


@lru_cache()
def _enrich(ddi):
    uri = ddi['uri']
    result = {
        'harmful': bool(_sha_int(uri) % 2),
        'spacing': _sha_int(uri) % 14 + 1,

        # we want them to be a bit different
        'agonism': bool(_sha_int(''.join(sorted(uri))) % 2),
    }

    result.update(ddi)
    return result

def enrich(ddis):
    return [_enrich(ddi) for ddi in ddis]
