output "instances" {
  value = "${data.google_compute_region_instance_group.default.instances}"
}
