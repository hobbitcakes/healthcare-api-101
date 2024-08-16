resource "google_project_service" "project" {
  project = "${var.project_id}"
  service = "healthcare.googleapis.com"

  timeouts {
    create = "10m"
    update = "10m"
  }
}

resource "google_healthcare_dataset" "dataset" {
  depends_on = [google_project_service.project]
  provider = google
  name      = "101-dataset-${random_pet.pet.id}"
  location  = "${var.region}"
  time_zone = "UTC"
}

resource "google_healthcare_hl7_v2_store" "hl7v2store" {
  provider = google
  name = "hl7v2store-${random_pet.pet.id}"
  dataset  = google_healthcare_dataset.dataset.id

  notification_configs {
    pubsub_topic = google_pubsub_topic.hl7v2.id
  }
}

resource "google_healthcare_fhir_store" "fhirstore" {
  provider = google-beta
  name     = "fhirstore-${random_pet.pet.id}"
  dataset  = google_healthcare_dataset.dataset.id
  version  = "R4"

  complex_data_type_reference_parsing = "DISABLED"
  enable_update_create          = false
  disable_referential_integrity = false
  disable_resource_versioning   = false
  enable_history_import         = false

  notification_configs {
    pubsub_topic                     = "${google_pubsub_topic.fhir.id}"
    send_full_resource               = false
    send_previous_resource_on_delete = false
  }

  notification_configs {
    pubsub_topic                     = "${google_pubsub_topic.full-fhir.id}"
    send_full_resource               = true
    send_previous_resource_on_delete = true
  }
}

// TODO: Add deid to the 101
#resource "google_project_iam_custom_role" "deid-exporter-iam" {
#  role_id     = "fhir-deid-exporter"
#  title       = "FHIR Deid Exporter"
#  description = "IAM necessary to Deid a FHIR Store"
#  permissions = ["iam.roles.list", "healthcare.fhirResources.update", "iam.roles.delete"]
#}

#resource "google_healthcare_fhir_store_iam_binding" "de-id" {
#  fhir_store_id = "${google_healthcare_fhir_store.fhirstore.id}"
#  role          = "roles/editor"

  #  members = [
    #    "user:jane@example.com",
    #  ]
  #}
