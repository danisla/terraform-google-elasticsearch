data "google_client_config" "current" {}

data "google_compute_image" "elasticsearch" {
  family  = "${var.image_family}"
  project = "${var.image_project == "" ? data.google_client_config.current.project : var.image_project}"
}

data "template_file" "node-startup-script" {
  template = "${file("${path.module}/config/user_data.sh")}"

  vars {
    project_id             = "${var.project == "" ? data.google_client_config.current.project : var.project}"
    zones                  = "${join(",", var.zones)}"
    elasticsearch_data_dir = "${var.elasticsearch_data_dir}"
    elasticsearch_logs_dir = "${var.elasticsearch_logs_dir}"
    heap_size              = "${var.heap_size}"
    cluster_name           = "${var.cluster_name}"
    minimum_master_nodes   = "${format("%d", var.masters_count / 2 + 1)}"
    master                 = "${var.master_node ? "true" : "false"}"
    data                   = "${var.data_node ? "true" : "false"}"
    ingest                 = "${var.ingest_node ? "true" : "false"}"
    http_enabled           = "${var.http_enabled ? "true" : "false"}"
    security_enabled       = "${var.security_enabled ? "true" : "false"}"
    monitoring_enabled     = "${var.monitoring_enabled ? "true" : "false"}"
  }
}

module "node" {
  source                    = "github.com/GoogleCloudPlatform/terraform-google-managed-instance-group"
  project                   = "${var.project == "" ? data.google_client_config.current.project : var.project}"
  region                    = "${var.region}"
  zonal                     = false
  distribution_policy_zones = ["${var.zones}"]
  network                   = "${var.network}"
  subnetwork                = "${var.subnetwork}"
  network_ip                = "${var.network_ip}"
  access_config             = ["${var.access_config}"]
  target_tags               = ["${compact(concat(list("${var.name}", "${var.cluster_name}"), var.node_tags))}"]
  machine_type              = "${var.machine_type}"
  name                      = "${var.name}"
  compute_image             = "${data.google_compute_image.elasticsearch.self_link}"
  disk_auto_delete          = "${var.disk_auto_delete}"
  disk_type                 = "${var.disk_type}"
  disk_size_gb              = "${var.disk_size_gb}"
  size                      = "${var.num_nodes}"
  service_port              = "9200"
  service_port_name         = "http"
  startup_script            = "${data.template_file.node-startup-script.rendered}"
  wait_for_instances        = true
  update_strategy           = "NONE"
}

data "google_compute_region_instance_group" "default" {
  self_link = "${module.node.region_instance_group}"
}
