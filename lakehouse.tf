resource "google_pubsub_topic" "sub-to-gcs-deadletter" {
  name = "${random_pet.pet.id}-full-patient-to-gcs-deadletter"
}

resource "google_pubsub_subscription" "full-patient-to-gcs" {
  name  = "${random_pet.pet.id}-full-patient-to-gcs"
  topic = google_pubsub_topic.full-fhir.name

  cloud_storage_config {
    bucket = google_storage_bucket.output-bucket.name
    filename_prefix = "${random_pet.pet.id}"
    filename_suffix = "-patient-"

    avro_config {
      write_metadata = true
    }
  }

  dead_letter_policy {
    dead_letter_topic = google_pubsub_topic.sub-to-gcs-deadletter.id
    max_delivery_attempts = 10
  }

  # 1 day
  message_retention_duration = "86400s"
  retain_acked_messages      = true
  ack_deadline_seconds = 300

  expiration_policy {
    ttl = "300000.5s"
  }
  retry_policy {
    minimum_backoff = "10s"
  }
  filter = "attributes.resourceType =\"Patient\""

  enable_message_ordering    = false
}
