def enrich(ddis):
    def _agonist(uri):
        return bool(hash(uri) & 2)

    def _spacing(uri):
        return (hash(uri) & 0xf) + 1

    def _enrich(ddi):
        result = {
            'agonistic': _agonist(ddi['uri']),
            'spacing': _spacing(ddi['uri']),
        }

        result.update(ddi)
        return result

    return [_enrich(ddi) for ddi in ddis]
