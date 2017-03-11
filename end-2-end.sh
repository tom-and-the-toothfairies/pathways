#!/bin/bash

docker logs -f pathways_athloi_1
exit `docker wait pathways_athloi_1`
