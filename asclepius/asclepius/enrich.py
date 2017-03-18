def enrich(ddis):
    def _enrich(ddi):
        result = {'harmful': bool(hash(ddi['uri']) % 2),
                  'spacing': abs(hash(ddi['uri']))%14 + 1}
        result.update(ddi)
        return result

    return [_enrich(ddi) for ddi in ddis]
