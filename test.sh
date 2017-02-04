#!/bin/bash

echo "Testing martini mixing"
peos/pml/check/pmlcheck peos/compiler/models/martini.pml

echo "Testing some DINTO things"
python3 src/main.py DINTO/DINTO\ 1/DINTO\ 1\ additional\ material/DINTO\ 1\ reduced\ versions/DINTO_SEMEVAL2_inf.owl
