// Bastion host
data "google_compute_image" "bastion" {
  family  = "${var.bastion_image_family}"
  project = "${var.bastion_image_project == "" ? data.google_client_config.current.project : var.bastion_image_project}"
}

module "bastion" {
  source            = "../../stateful_node"
  name              = "${var.cluster_name}-bastion"
  region            = "${var.region}"
  zones             = ["${element(var.zones, 1)}"]
  num_nodes         = 1
  machine_type      = "${var.bastion_machine_type}"
  min_cpu_platform  = "Intel Skylake"
  boot_image_url    = "${var.bastion_image_url == "" ? data.google_compute_image.bastion.self_link : var.bastion_image_url}"
  boot_disk_size_gb = "${var.bastion_disk_size}"
  node_tags         = ["${var.cluster_name}-bastion", "${var.cluster_name}-external", "${var.cluster_name}"]
  network           = "${google_compute_subnetwork.default.name}"
  subnetwork        = "${google_compute_subnetwork.default.name}"
  access_config     = [{}]
  data_node         = false
  startup_script    = ":"
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

// output "bastion_instance" {
//   value = "${element(module.bastion.instances[0], 0)}"
// }

output "bastion_instance" {
  value = "${element(module.bastion.instances, 0)}"
}

output "bastion" {
  value = "gcloud compute ssh --ssh-flag=\"-A -L :9000:$(terraform output kibana_hostname):9000 -L :5601:$(terraform output kibana_hostname):5601\" $(terraform output bastion_instance)"
}
