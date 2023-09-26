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

```bash
bin/download-cooherent-fhir-in-bulk.sh
gsutil -m cp * gs://${gcs_bucket}/in/
```


