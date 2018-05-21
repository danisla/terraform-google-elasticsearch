// Client internal client load balancer IP address
resource "google_compute_address" "es_client_ilb" {
  name         = "${var.cluster_name}-client-ilb"
  address_type = "INTERNAL"
  subnetwork   = "${google_compute_subnetwork.default.self_link}"
}

// Client internal load balancer
module "es_client_ilb" {
  source            = "github.com/GoogleCloudPlatform/terraform-google-lb-internal"
  region            = "${var.region}"
  name              = "${var.cluster_name}-client-ilb"
  ip_address        = "${google_compute_address.es_client_ilb.address}"
  ports             = ["9200", "9300"]
  health_port       = "9200"
  http_health_check = true
  source_tags       = ["${var.cluster_name}-kibana", "${var.cluster_name}-external"]
  target_tags       = ["${var.cluster_name}-client"]
  network           = "${google_compute_subnetwork.default.name}"
  subnetwork        = "${google_compute_subnetwork.default.name}"

  backends = [
    {
      group = "${module.es_client.instance_group}"
    },
  ]
}

// Indexing internal load balancer IP address.
resource "google_compute_address" "es_indexing_ilb" {
  name         = "${var.cluster_name}-indexing-ilb"
  address_type = "INTERNAL"
  subnetwork   = "${google_compute_subnetwork.default.self_link}"
}

// Indexing internal load balancer
module "es_indexing_ilb" {
  source            = "github.com/GoogleCloudPlatform/terraform-google-lb-internal"
  region            = "${var.region}"
  name              = "${var.cluster_name}-indexing-ilb"
  ip_address        = "${google_compute_address.es_indexing_ilb.address}"
  ports             = ["9200", "9300"]
  health_port       = "9200"
  http_health_check = true
  source_tags       = ["${var.cluster_name}-external"]
  target_tags       = ["${var.cluster_name}-indexing"]
  network           = "${google_compute_subnetwork.default.name}"
  subnetwork        = "${google_compute_subnetwork.default.name}"

  backends = [
    {
      group = "${module.es_indexing.instance_group}"
    },
  ]
}
