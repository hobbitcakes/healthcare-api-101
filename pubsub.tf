resource "google_pubsub_topic" "hl7v2" {
  provider = google
  name     = "${random_pet.pet.id}-hl7v2-topic"
}

resource "google_pubsub_topic" "fhir" {
  provider = google
  name     = "${random_pet.pet.id}-fhir-topic"
}

resource "google_pubsub_subscription" "fhir-notifications" {
  name  = "${random_pet.pet.id}-fhir-notifications"
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
  name     = "${random_pet.pet.id}-full-fhir-topic"
}

resource "google_pubsub_subscription" "full-fhir-notifications" {
  name  = "${random_pet.pet.id}-full-fhir-notifications"
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

resource "google_pubsub_subscription" "full-patient-notifications" {
  name  = "${random_pet.pet.id}-full-patient-notifications"
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
  filter = "attributes.resourceType =\"Patient\""

  enable_message_ordering    = false
}

resource "google_pubsub_subscription" "hl7v2-notifications" {
  name  = "${random_pet.pet.id}-hl7v2-notifications"
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
