provider "google" {
  region = "${var.region}"
}

data "google_client_config" "current" {}

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

// Master nodes
module "es_master" {
  source        = "../../"
  cluster_name  = "${var.cluster_name}"
  name          = "${var.cluster_name}-master"
  region        = "${var.region}"
  zones         = "${var.zones}"
  num_nodes     = "${var.master_num_nodes}"
  machine_type  = "${var.master_machine_type}"
  heap_size     = "${var.master_heap_size}"
  masters_count = "${var.master_num_nodes}"
  master_node   = true
  data_node     = false
  access_config = []
  network       = "${google_compute_subnetwork.default.name}"
  subnetwork    = "${google_compute_subnetwork.default.name}"
}

// Data nodes
module "es_data" {
  source        = "../../"
  cluster_name  = "${var.cluster_name}"
  name          = "${var.cluster_name}-data"
  region        = "${var.region}"
  zones         = "${var.zones}"
  num_nodes     = "${var.data_num_nodes}"
  machine_type  = "${var.data_machine_type}"
  heap_size     = "${var.data_heap_size}"
  disk_size_gb  = "${var.data_disk_size}"
  disk_type     = "${var.data_disk_type}"
  masters_count = "${var.master_num_nodes}"
  master_node   = false
  data_node     = true
  access_config = []
  network       = "${google_compute_subnetwork.default.name}"
  subnetwork    = "${google_compute_subnetwork.default.name}"
}

// Client nodes
module "es_client" {
  source        = "../../"
  cluster_name  = "${var.cluster_name}"
  name          = "${var.cluster_name}-client"
  region        = "${var.region}"
  zones         = "${var.zones}"
  num_nodes     = "${var.client_num_nodes}"
  machine_type  = "${var.client_machine_type}"
  heap_size     = "${var.client_heap_size}"
  masters_count = "${var.master_num_nodes}"
  master_node   = false
  data_node     = false
  access_config = []
  network       = "${google_compute_subnetwork.default.name}"
  subnetwork    = "${google_compute_subnetwork.default.name}"
}

// Indexing nodes
module "es_indexing" {
  source        = "../../"
  cluster_name  = "${var.cluster_name}"
  name          = "${var.cluster_name}-indexing"
  region        = "${var.region}"
  zones         = "${var.zones}"
  num_nodes     = "${var.indexing_num_nodes}"
  machine_type  = "${var.indexing_machine_type}"
  heap_size     = "${var.indexing_heap_size}"
  masters_count = "${var.master_num_nodes}"
  master_node   = false
  data_node     = false
  access_config = []
  network       = "${google_compute_subnetwork.default.name}"
  subnetwork    = "${google_compute_subnetwork.default.name}"
}

// NAT gateway
// module "nat-gateway" {
//   source     = "github.com/GoogleCloudPlatform/terraform-google-nat-gateway"
//   region     = "${var.region}"
//   zone       = "${element(var.zones, 0)}"
//   network    = "${google_compute_subnetwork.default.name}"
//   subnetwork = "${google_compute_subnetwork.default.name}"
//   tags       = ["${var.cluster_name}"]
// }

// Kibana
module "kibana" {
  source            = "../../kibana"
  name              = "${var.cluster_name}-kibana"
  region            = "${var.region}"
  zones             = ["${var.zones}"]
  access_config     = []
  num_nodes         = 1
  elasticsearch_url = "http://${module.es_client_ilb.ip_address}:9200"
  network           = "${google_compute_subnetwork.default.name}"
  subnetwork        = "${google_compute_subnetwork.default.name}"
}

// Cluster firewall
resource "google_compute_firewall" "cluster" {
  name    = "${var.cluster_name}"
  network = "${google_compute_subnetwork.default.name}"

  allow {
    protocol = "tcp"
    ports    = ["9200", "9300"]
  }

  source_tags = ["${var.cluster_name}", "${var.cluster_name}-external"]
  target_tags = ["${var.cluster_name}"]
}

output "kibana_hostname" {
  value = "${basename(lookup(module.kibana.instances[0], "instance"))}"
}

output "client_endpoint" {
  value = "http://${module.es_client_ilb.ip_address}:9200"
}

output "indexing_endpoint" {
  value = "http://${module.es_indexing_ilb.ip_address}:9200"
}
