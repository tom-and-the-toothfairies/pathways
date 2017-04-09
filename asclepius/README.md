Asclepius ⚕
===========

Flask endpoint for querying DINTO. Supports querying for all drugs listed, as
well as finding all, or specific drug-drug interactions.

This application acts as an adaptor to Chiron - an instance of Apache Fuseki,
Chiron must be running before any queries can be served.

CSV File Exporting
------------------

When run as a program, the `enrich` module will export DDIs, along with mock
timing and agonism/harmfulness information.

Run as `python3 enrich.py <harmful|agonism> > outfile.csv` to export to a CSV file.

HTTP Endpoints
-------------

### `/all_drugs`

|             |                                                                                       |
|-------------|---------------------------------------------------------------------------------------|
| Description | Find all drugs in the DINTO ontology                                                  |
| Methods     | `GET`                                                                                 |
| Parameters  | None                                                                                  |
| Returns     | A list containing pairs of the canonical URI for a drug, as well as its English Label |

#### Example

##### Response Body (Truncated)

```json
[
  {
    "label": "carbapenem MM22383",
    "uri": "http://purl.obolibrary.org/obo/CHEBI_58998"
  },
  {
    "label": "adenosine-5'-ditungstate",
    "uri": "http://purl.obolibrary.org/obo/DINTO_DB02183"
  },
  {
    "label": "(5z)-13-chloro-14,16-dihydroxy-3,4,7,8,9,10-hexahydro-1h-2-benzoxacyclotetradecine-1,11(12h)-dione",
    "uri": "http://purl.obolibrary.org/obo/DINTO_DB08346"
  },
  {
    "label": "etoposide",
    "uri": "http://purl.obolibrary.org/obo/CHEBI_4911"
  }
]
```

### `/all_ddis`

|             |                                                                                                                                             |
|-------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| Description | Find all drug-drug interactions (DDIs) in the DINTO ontology                                                                                |
| Methods     | `GET`                                                                                                                                       |
| Parameters  | None                                                                                                                                        |
| Returns     | A list containing pairs of the canonical URI for a drug-drug interaction, as well as its English label and the labels of the drugs involved |

#### Example

##### Response Body (Truncated)

```json
[
  {
    "label": "torasemide/trandolapril DDI",
    "uri": "http://purl.obolibrary.org/obo/DINTO_11031",
    "drug_a": "torasemide",
    "drug_b": "trandolapril"
  },
  {
    "label": "cimetidine/heroin DDI",
    "uri": "http://purl.obolibrary.org/obo/DINTO_02733",
    "drug_a": "cimetidine",
    "drug_b": "heroin"
  },
  {
    "label": "methylergonovine/telithromycin DDI",
    "uri": "http://purl.obolibrary.org/obo/DINTO_10154",
    "drug_a": "methylergonovine",
    "drug_b": "telithromycin"
  }
]
```

### `/ddis`

|              |                                                                                                                                                                                                                             |
|--------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Description  | Find all drug-drug interactions (DDI) in the DINTO ontology which involve only the *given* drugs                                                                                                                            |
| Methods      | `POST`                                                                                                                                                                                                                      |
| Request Body | An object containing a list of *DINTO URIs*                                                                                                                                                                                 |
| Returns      | A list of DDI objects; its label, its URI, the identifiers of the two drugs involved, the spacing between dosages required to avoid the DDI as well as whether or not it is a harmful interaction and an agonism/antagonism |
|              |                                                                                                                                                                                                                             |

#### Example
##### Request Body
```json
{
  "drugs": [
    "http://purl.obolibrary.org/obo/DINTO_DB00214",
    "http://purl.obolibrary.org/obo/DINTO_DB00519"
  ]
}
```

##### Response Body

```json
[
  {
    "drug_a": "http://purl.obolibrary.org/obo/DINTO_DB00214",
    "drug_b": "http://purl.obolibrary.org/obo/DINTO_DB00519",
    "label": "torasemide/trandolapril DDI",
    "uri": "http://purl.obolibrary.org/obo/DINTO_11031",
    "harmful": true,
    "spacing": 2,
    "unit": "yr",
    "agonism": true
  }
]
```
### `/uris`

|              |                                                                                            |
|--------------|--------------------------------------------------------------------------------------------|
| Description  | For a given list of drug labels, find their *DINTO URIs* (to be used when calling `/ddis`) |
| Methods      | `POST`                                                                                     |
| Request Body | An object containing a list of drug labels, named `labels`                                 |
| Returns      | See below                                                                                  |

#### Example

##### Request Body

```json
{"labels": [ "paracetamol", "flat seven up", "cocaine"]}
```

##### Response Body

```json
{
  "found": [
    {
      "label": "cocaine",
      "uri": "http://purl.obolibrary.org/obo/CHEBI_27958"
    },
    {
      "label": "paracetamol",
      "uri": "http://purl.obolibrary.org/obo/CHEBI_46195"
    }
  ],
  "not_found": [
    "flat seven up"
  ]
}

```
