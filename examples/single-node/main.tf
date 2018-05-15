variable "cluster_name" {
  default = "tf-es-test"
}

variable "region" {
  default = "us-west1"
}

variable "zones" {
  type    = "list"
  default = ["us-west1-b"]
}

variable "network_name" {
  default = "tf-es-test"
}

provider "google" {
  region = "${var.region}"
}

resource "google_compute_network" "default" {
  name                    = "${var.network_name}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name                     = "${var.network_name}"
  ip_cidr_range            = "10.127.0.0/20"
  network                  = "${google_compute_network.default.self_link}"
  region                   = "${var.region}"
  private_ip_google_access = true
}

// Consistent internal IP for Elasticsearch node.
resource "google_compute_address" "es" {
  name         = "${var.cluster_name}-node"
  address_type = "INTERNAL"
  subnetwork   = "${google_compute_subnetwork.default.self_link}"
}

// Elasticsearch node
module "es" {
  source        = "../../"
  name          = "${var.cluster_name}"
  region        = "${var.region}"
  zones         = ["${var.zones}"]
  network_ip    = "${google_compute_address.es.address}"
  access_config = []
  network       = "${google_compute_subnetwork.default.name}"
  subnetwork    = "${google_compute_subnetwork.default.name}"
}

// Kibana
module "kibana" {
  source            = "../../kibana"
  name              = "${var.cluster_name}-kibana"
  region            = "${var.region}"
  zones             = ["${var.zones}"]
  num_nodes         = 1
  node_tags         = ["${var.cluster_name}"]
  elasticsearch_url = "http://${google_compute_address.es.address}:9200"
  network           = "${google_compute_subnetwork.default.name}"
  subnetwork        = "${google_compute_subnetwork.default.name}"
}

// Node firewall
resource "google_compute_firewall" "cluster" {
  name    = "${var.cluster_name}"
  network = "${google_compute_subnetwork.default.name}"

  allow {
    protocol = "tcp"
    ports    = ["9200", "9300"]
  }

  source_tags = ["${var.cluster_name}"]
  target_tags = ["${var.cluster_name}"]
}

output "kibana_instance" {
  value = "${lookup(module.kibana.instances[0], "instance")}"
}

output "kibana" {
  value = "gcloud compute ssh --ssh-flag=\"-A -L :9000:localhost:9000 -L :5601:localhost:5601\" $(terraform output kibana_instance)"
}
