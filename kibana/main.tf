data "google_client_config" "current" {}

data "google_compute_image" "kibana" {
  family = "${var.image_family}"
}

data "template_file" "node-startup-script" {
  template = "${file("${path.module}/config/user_data.sh")}"

  vars {
    project_id         = "${var.project == "" ? data.google_client_config.current.project : var.project}"
    zones              = "${join(",", var.zones)}"
    elasticsearch_url  = "${var.elasticsearch_url}"
    security_enabled   = "${var.security_enabled ? "true" : "false"}"
    monitoring_enabled = "${var.monitoring_enabled ? "true" : "false"}"
  }
}

module "kibana" {
  source                    = "GoogleCloudPlatform/managed-instance-group/google"
  version                   = "1.1.13"
  project                   = "${var.project == "" ? data.google_client_config.current.project : var.project}"
  region                    = "${var.region}"
  zonal                     = false
  distribution_policy_zones = ["${var.zones}"]
  network                   = "${var.network}"
  subnetwork                = "${var.subnetwork}"
  access_config             = ["${var.access_config}"]
  target_tags               = ["${compact(concat(list("${var.name}"), var.node_tags))}"]
  machine_type              = "${var.machine_type}"
  name                      = "${var.name}"
  compute_image             = "${data.google_compute_image.kibana.self_link}"
  size                      = "${var.num_nodes}"
  disk_auto_delete          = "${var.disk_auto_delete}"
  disk_type                 = "${var.disk_type}"
  disk_size_gb              = "${var.disk_size_gb}"
  service_port              = "5601"
  service_port_name         = "http"
  startup_script            = "${data.template_file.node-startup-script.rendered}"
  wait_for_instances        = true
  http_health_check         = false
  update_strategy           = "ROLLING_UPDATE"

  rolling_update_policy = [
    {
      type                  = "PROACTIVE"
      minimal_action        = "REPLACE"
      max_surge_fixed       = "${length(var.zones)}"
      max_unavailable_fixed = 0
    },
  ]
}

data "google_compute_region_instance_group" "default" {
  self_link = "${module.kibana.region_instance_group}"
}
