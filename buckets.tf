resource "google_storage_bucket" "input-bucket" {
  name = "${var.project_id}-input-${random_pet.pet.id}"
  location = "${var.region}"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket" "output-bucket" {
  name = "${var.project_id}-output-${random_pet.pet.id}"
  location = "${var.region}"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_binding" "binding" {
  depends_on = [google_project_service.project]
  bucket = google_storage_bucket.input-bucket.name
  role = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:service-${data.google_project.project.number}@gcp-sa-healthcare.iam.gserviceaccount.com",
  ]
}

resource "google_storage_bucket_iam_member" "admin" {
  bucket = google_storage_bucket.output-bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}
