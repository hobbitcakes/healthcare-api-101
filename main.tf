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

resource "google_project_service" "pubsub" {
  service = "pubsub.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "healthcare" {
  service = "healthcare.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "project" {
  service = "healthcare.googleapis.com"
  disable_on_destroy = false
}
resource "random_pet" "pet" {
  keepers = {
    project_id = "${var.project_id}"
  }
}
