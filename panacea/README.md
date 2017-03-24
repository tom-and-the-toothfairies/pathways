# Panacea

Service responsible for the UI and PML analysis. The UI is a web app available
at [localhost:4000](localhost:4000). Panacea depends on both Asclepius and
Chiron to provide DDI analysis, these must be running for Panacea to work.


Api Endpoints
-------------

All API endpoints require a valid *authorization token* to be provided. The
*token* can be sent in the *Authorization* header or as the
*authorization_token* query parameter.

Tokens can be generated using: `Panacea.AccessToken.generate()`

### `/api/pml`


|             |                                                    |
|-------------|----------------------------------------------------|
| Description | Validate a PML file and find the drugs it contains |
| Methods     | `POST`                                             |
| Parameters  | An object containing the *file* to be analysed     |
| Returns     | Response detailed below, or an error object        |

#### Example

##### Response Body

```json
{
  "drugs": [
    {
      "label": "paracetamol",
      "line": 12
    },
    {
      "label": "cocaine",
      "line": 2
    }
  ],
  "unnamed": [
    {
      "type": "task",
      "line": 3
    },
    {
      "type": "sequence",
      "line": 6
    }
  ],
  "clashes": [
    {
      "name": "some_action",
      "occurrences": [
        {"line": 9, "type": "action"},
        {"line": 3, "type": "action"}
      ]
    }
  ],
  "ast": "AST representation of the provided PML file - base64 encoded"
}
```

### `/api/uris`

|              |                                                             |
|--------------|-------------------------------------------------------------|
| Description  | For a given list of drug labels, find their DINTO URI       |
| Methods      | `POST`                                                      |
| Request Body | An object containing a list of drug labels, named `labels`  |
| Returns      | Response detailed below or and error object                 |

#### Example

##### Request Body

```json
{"labels": [ "paracetamol", "flat seven up", "cocaine"]}
```

##### Response Body

```json
{
  "uris": {
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
}
```

### `/api/ddis`

|              |                                                                                                  |
|--------------|--------------------------------------------------------------------------------------------------|
| Description  | Find all drug-drug interactions (DDI) in the DINTO ontology which involve only the *given* drugs |
| Methods      | `POST`                                                                                           |
| Request Body | An object containing a list of *DINTO URIs*                                                      |
| Returns      | Response detailed below, or an error object                                                      |

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
{
  "ddis": [
    {
      "drug_a": "http://purl.obolibrary.org/obo/DINTO_DB00214",
      "drug_b": "http://purl.obolibrary.org/obo/DINTO_DB00519",
      "label": "torasemide/trandolapril DDI",
      "uri": "http://purl.obolibrary.org/obo/DINTO_11031",
      "harmful": false,
      "spacing": 3
    }
  ]
}
```

### Error Objects

All error responses take have the following format:

```json
{
  "error": {
    "status_code": "http status code",
    "title": "string summarising the error",
    "detail": "string explaining the specific error",
    "meta": "object containing error specific metadata"
  }
}
```

### `/api/ast`

|             |                                                                          |
|-------------|------------------------------------------------------------------------- |
| Description | Convert an PML AST into a PML Document                                   |
| Methods     | `POST`                                                                   |
| Parameters  | An object containing the *pml ast* to be converted                       |
| Returns     | The PML document as an attachment named `pml-tx.pml`, or an error object |
