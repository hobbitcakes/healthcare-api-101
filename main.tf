provider "google-beta" {
  project     = "${var.project_id}"
  region      = "${var.region}"
}
provider "google" {
  project     = "${var.project_id}"
  region      = "${var.region}"
}

data "google_project" "project" {
  project_id = "${var.project_id}"
}

resource "random_pet" "pet" {
  keepers = {
    project_id = "${var.project_id}"
  }
}

resource "google_project_service" "project" {
  project = "${var.project_id}"
  service = "healthcare.googleapis.com"

  timeouts {
    create = "10m"
    update = "10m"
  }
}

resource "google_healthcare_dataset" "dataset" {
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
    send_full_resource               = true
    send_previous_resource_on_delete = true
  }

  notification_configs {
    pubsub_topic                     = "${google_pubsub_topic.full-fhir.id}"
    send_full_resource               = true
    send_previous_resource_on_delete = true
  }
}

resource "google_pubsub_topic" "hl7v2" {
  provider = google
  name     = "hl7v2-topic"
}

resource "google_pubsub_topic" "fhir" {
  provider = google
  name     = "fhir-topic"
}

resource "google_pubsub_subscription" "fhir-notifications" {
  name  = "fhir-notifications"
  topic = google_pubsub_topic.fhir.name
  
  # 1 day
  message_retention_duration = "86400s"
  retain_acked_messages      = true

  ack_deadline_seconds = 20

  expiration_policy {
    ttl = "300000.5s"
  }
  retry_policy {
    minimum_backoff = "10s"
  }

  enable_message_ordering    = false
}

resource "google_pubsub_topic" "full-fhir" {
  provider = google
  name     = "full-fhir-topic"
}

resource "google_pubsub_subscription" "full-fhir-notifications" {
  name  = "full-fhir-notifications"
  topic = google_pubsub_topic.full-fhir.name

  # 1 day
  message_retention_duration = "86400s"
  retain_acked_messages      = true

  ack_deadline_seconds = 20

  expiration_policy {
    ttl = "300000.5s"
  }
  retry_policy {
    minimum_backoff = "10s"
  }

  enable_message_ordering    = false
}


resource "google_pubsub_subscription" "hl7v2-notifications" {
  name  = "hl7v2-notifications"
  topic = google_pubsub_topic.hl7v2.name

  # 20 minutes
  message_retention_duration = "1200s"
  retain_acked_messages      = true

  ack_deadline_seconds = 20

  expiration_policy {
    ttl = "300000.5s"
  }
  retry_policy {
    minimum_backoff = "10s"
  }

  enable_message_ordering    = false
}

resource "google_storage_bucket" "input-bucket" {
  name = "${var.project_id}-input-${random_pet.pet.id}"
  location = "${var.region}"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_binding" "binding" {
  bucket = google_storage_bucket.input-bucket.name
  role = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-healthcare.iam.gserviceaccount.com",
  ]
}
