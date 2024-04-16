# Healthcare API 101
The Google Healthcare API provides a host of functionality for healthcare data,
processing and inference. This intro will touch the surface of what the
Healthcare API can do while hinting at deeper application, analytics and AI
capabilities

## Setup
Provided is a default terraform script that will allow exploration of the
Healthcare API. Note that this will incur Google Cloud costs, though they will
likely be minor. Ensure you understand the impact of standing up this
infrastructure.

Additionally, synthetic data is provided and used throughout this intro. If you
choose to use your own data (institutional synthetic or PHI), do so with
caution as this intro assumes synthetic data.

### Clone down the repo
```bash
git clone git:<TODO>
cd healthcare-api-101/
```

### Create a terraform.tfvars file and populate it with values that fulfill variables.tf
```bash
vim|nano terraform.tfvars

cat terraform.tfvars
>project_id = "my-demo-env"
>region = "us-central1"
```

### Create the environment
```bash
terraform init
terraform plan # You're responsible for checking this!!
terraform apply
```
Note: You may need to run terraform apply multiple times as it can take a few
minutes for the Healthcare API to be enabled and usable by Terraform.

### Save the Terraform variables with the following bash script
```bash
bin/store-env-vars.sh
```
### Get started!
Anytime you're working in this repo, ensure you "source" the environment.out
file. This sets variables inside your shell that keep track of the names of the
Google Cloud resources Terraform created for you. Many of the scripts in the
bin/ directory rely on these environment variables being set.

```bash
source environment.out
```

## The hl7V2Store

## The fhirStore

### Load FHIR Data
To begin, let's do a few things. Load our first few (thousand) FHIR "Reference" Resources. And then Load a Patient and their associated Longitudinal Record. Finally, we'll download a much larger dataset we will use later provided by the Coherent Dataset from MITRE.

#### Setup
```bash
# 
cd healthcare-api-101/
source environment.out
cd data/fhir/bundle
```
#### Load Reference data
```bash
bundle ${fhir_url}/fhir -d @reference-orgs.json | jq '.'
bundle ${fhir_url}/fhir -d @reference-practitioners.json | jq '.'
```
#### Load our Patient "Kerry" and his Longitudinal Record
```bash
bundle ${fhir_url}/fhir -d @Kerry175_Gislason620_fe667044-eea1-3d0f-1b02-156eb1fd8b5c.json | jq '.'
```

Now that Kerry is loaded into the FHIR Store, you should have a single Patient Record. Let's do our first List operation!
```bash
get "${fhir_url}/fhir/Patient" | jq '.'
```

The JSON document returned will be a searchset containing Terry's "Patient" FHIR Resource. The below example is edited for brevity.

```json
{
  "entry": [ // <-- List of returned FHIR Resources
    { // <-- Start of the FHIR Resource
      "fullUrl": "https://healthcare.googleapis.com/v1/projects//locations//datasets/101-dataset/fhirStores/fhirstore/fhir/Patient/653be6d8-1d87-42ed-85e9-96ad518fad49",
      "resource": {
        "address": [
            {
            "city": "Somerset",
            "country": "US",
...
            }
        ]
      }
    } // <-- End of the FHIR Resource
  ]
  "link": [
...
  ],
  "resourceType": "Bundle",
  "total": 1, // <-- Number of matched results, not the number of returned resources
  "type": "searchset" // <-- Bundle type
}
```

The Patient search we just ran will be much too broad once we get more than one patient in our FHIR Store. Let's find the system id of the Patient. 
```bash
get "${fhir_url}/fhir/Patient" | jq -r '.entry[].resource.id'
# Example Output
653be6d8-1d87-42ed-85e9-96ad518fad49
```
Let's store this value and then use it to directly get Kerry's Patient FHIR Resource.

```bash
KERRY_ID=$(get "${fhir_url}/fhir/Patient" | jq -r '.entry[].resource.id')
echo $KERRY_ID
# Example output:
653be6d8-1d87-42ed-85e9-96ad518fad49

get "${fhir_url}/fhir/Patient/${KERRY_ID}" | jq '.'
```

You should have gotten the same large JSON object that we saw earlier with a notable difference. The JSON object returned was the resource itself. There is not an `entry[]` array or a `link[]` array or any `resourceType`, `total`, `type` objects. The return type of the direct GET fhir/<resourceType>/<uuid> returns a FHIR Object.

```bash
bin/download-cooherent-fhir-in-bulk.sh
gsutil -m cp * gs://${gcs_bucket}/in/
```


