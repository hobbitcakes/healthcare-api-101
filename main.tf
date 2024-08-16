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
