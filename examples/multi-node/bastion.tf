// Bastion host
data "google_compute_image" "bastion" {
  family  = "${var.bastion_image_family}"
  project = "${var.bastion_image_project == "" ? data.google_client_config.current.project : var.bastion_image_project}"
}

module "bastion" {
  source             = "github.com/GoogleCloudPlatform/terraform-google-managed-instance-group"
  region             = "${var.region}"
  zone               = "${element(var.zones, 0)}"
  network            = "${google_compute_subnetwork.default.name}"
  subnetwork         = "${google_compute_subnetwork.default.name}"
  target_tags        = ["${var.cluster_name}-bastion", "${var.cluster_name}-external"]
  machine_type       = "${var.bastion_machine_type}"
  disk_size_gb       = "${var.bastion_disk_size}"
  disk_type          = "${var.bastion_disk_type}"
  name               = "${var.cluster_name}-bastion"
  compute_image      = "${var.bastion_image_url == "" ? data.google_compute_image.bastion.self_link : var.bastion_image_url}"
  http_health_check  = false
  service_port       = "80"
  service_port_name  = "http"
  wait_for_instances = true
}

// Bastion firewall
resource "google_compute_firewall" "bastion" {
  name    = "${var.cluster_name}-bastion"
  network = "${google_compute_subnetwork.default.name}"

  allow {
    protocol = "tcp"
    ports    = ["5601", "9000"]
  }

  source_tags = ["${var.cluster_name}-bastion"]
  target_tags = ["${var.cluster_name}-kibana"]
}

output "bastion_instance" {
  value = "${element(module.bastion.instances[0], 0)}"
}

output "bastion" {
  value = "gcloud compute ssh --ssh-flag=\"-A -L :9000:$(terraform output kibana_hostname):9000 -L :5601:$(terraform output kibana_hostname):5601\" $(terraform output bastion_instance)"
}
