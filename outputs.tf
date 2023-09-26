output "project_id" {
  value = "${var.project_id}"
}

output "gcs_bucket" {
  value = google_storage_bucket.input-bucket.name 
}

output "dataset" {
  value = google_healthcare_dataset.dataset.id
}

output "hl7v2store" {
  value = google_healthcare_hl7_v2_store.hl7v2store.name
}

output "fhirstore" {
  value = google_healthcare_fhir_store.fhirstore.name
}

output "hl7v2_subscription" {
  value = google_pubsub_subscription.hl7v2-notifications.name
}

output "fhir_subscription" {
  value = google_pubsub_subscription.fhir-notifications.name
}

output "full_fhir_subscription" {
  value = google_pubsub_subscription.full-fhir-notifications.name

}
output "fhir_prefix" {
  value = "https://healthcare.googleapis.com/v1"
}

output "fhir_url" {
  value = "https://healthcare.googleapis.com/v1/${google_healthcare_dataset.dataset.id}/fhirStores/${google_healthcare_fhir_store.fhirstore.name}"
}

