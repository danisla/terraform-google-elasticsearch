data "google_project" "current" {}

data "google_compute_default_service_account" "default" {}

data "google_compute_image" "node" {
  family  = "${var.boot_image_family}"
  project = "${var.boot_image_project == "" ? data.google_project.current.project_id : var.boot_image_project}"
}

data "template_file" "node-startup-script" {
  template = "${file("${path.module}/config/user_data.sh")}"

  vars {
    project_id             = "${var.project == "" ? data.google_project.current.project_id : var.project}"
    zones                  = "${join(",", var.zones)}"
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

resource "google_compute_instance" "node" {
  count                     = "${var.data_node ? 0 : var.num_nodes}"
  name                      = "${var.name}-${count.index + 1}"
  zone                      = "${element(var.zones, count.index % length(var.zones))}"
  tags                      = ["${concat(list("${var.name}-ssh", "${var.cluster_name}"), var.node_tags)}"]
  machine_type              = "${var.machine_type}"
  min_cpu_platform          = "${var.min_cpu_platform}"
  allow_stopping_for_update = true

  // Local SSD disk
  scratch_disk {}

  boot_disk {
    auto_delete = "${var.boot_disk_auto_delete}"

    initialize_params {
      image = "${var.boot_image_url == "" ? data.google_compute_image.node.self_link : var.boot_image_url}"
      size  = "${var.boot_disk_size_gb}"
      type  = "${var.boot_disk_type}"
    }
  }

  network_interface {
    subnetwork    = "${var.subnetwork}"
    access_config = ["${var.access_config}"]
    address       = "${var.network_ip}"
  }

  metadata = "${merge(
    map("startup-script", "${var.startup_script == "" ? data.template_file.node-startup-script.rendered : var.startup_script}", "tf_depends_id", "${var.depends_id}"),
    var.metadata
  )}"

  service_account {
    email  = "${var.service_account_email == "" ? data.google_compute_default_service_account.default.email : var.service_account_email }"
    scopes = ["${var.service_account_scopes}"]
  }
}

resource "google_compute_instance" "data_node" {
  count                     = "${var.data_node ? var.num_nodes : 0}"
  name                      = "${var.name}-${count.index + 1}"
  zone                      = "${element(var.zones, count.index % length(var.zones))}"
  tags                      = ["${concat(list("${var.name}-ssh", "${var.cluster_name}"), var.node_tags)}"]
  machine_type              = "${var.machine_type}"
  min_cpu_platform          = "${var.min_cpu_platform}"
  allow_stopping_for_update = true

  attached_disk = [
    {
      source      = "${element(google_compute_disk.disk-1.*.self_link, count.index)}"
      device_name = "es-data-1"
      mode        = "READ_WRITE"
    },
    {
      source      = "${element(google_compute_disk.disk-2.*.self_link, count.index)}"
      device_name = "es-data-2"
      mode        = "READ_WRITE"
    },
    {
      source      = "${element(google_compute_disk.disk-3.*.self_link, count.index)}"
      device_name = "es-data-3"
      mode        = "READ_WRITE"
    },
    {
      source      = "${element(google_compute_disk.disk-4.*.self_link, count.index)}"
      device_name = "es-data-4"
      mode        = "READ_WRITE"
    },
  ]

  // Local SSD disk
  scratch_disk {}

  boot_disk {
    auto_delete = "${var.boot_disk_auto_delete}"

    initialize_params {
      image = "${var.boot_image_url == "" ? data.google_compute_image.node.self_link : var.boot_image_url}"
      size  = "${var.boot_disk_size_gb}"
      type  = "${var.boot_disk_type}"
    }
  }

  network_interface {
    subnetwork    = "${var.subnetwork}"
    access_config = ["${var.access_config}"]
    address       = "${var.network_ip}"
  }

  metadata = "${merge(
    map("startup-script", "${var.startup_script == "" ? data.template_file.node-startup-script.rendered : var.startup_script}", "tf_depends_id", "${var.depends_id}"),
    var.metadata
  )}"

  service_account {
    email  = "${var.service_account_email == "" ? data.google_compute_default_service_account.default.email : var.service_account_email }"
    scopes = ["${var.service_account_scopes}"]
  }
}

resource "google_compute_disk" "disk-1" {
  count = "${var.data_node ? var.num_nodes : 0}"
  name  = "${var.name}-${count.index + 1}-disk1"
  zone  = "${element(var.zones, count.index % length(var.zones))}"
  type  = "${lookup(var.attached_disk_1, "type")}"
  size  = "${lookup(var.attached_disk_1, "size")}"

  labels {
    es_cluster = "${var.cluster_name}"
  }
}

resource "google_compute_disk" "disk-2" {
  count = "${var.data_node ? var.num_nodes : 0}"
  name  = "${var.name}-${count.index + 1}-disk2"
  zone  = "${element(var.zones, count.index % length(var.zones))}"
  type  = "${lookup(var.attached_disk_2, "type")}"
  size  = "${lookup(var.attached_disk_2, "size")}"

  labels {
    es_cluster = "${var.cluster_name}"
  }
}

resource "google_compute_disk" "disk-3" {
  count = "${var.data_node ? var.num_nodes : 0}"
  name  = "${var.name}-${count.index + 1}-disk3"
  zone  = "${element(var.zones, count.index % length(var.zones))}"
  type  = "${lookup(var.attached_disk_3, "type")}"
  size  = "${lookup(var.attached_disk_3, "size")}"

  labels {
    es_cluster = "${var.cluster_name}"
  }
}

resource "google_compute_disk" "disk-4" {
  count = "${var.data_node ? var.num_nodes : 0}"
  name  = "${var.name}-${count.index + 1}-disk4"
  zone  = "${element(var.zones, count.index % length(var.zones))}"
  type  = "${lookup(var.attached_disk_4, "type")}"
  size  = "${lookup(var.attached_disk_4, "size")}"

  labels {
    es_cluster = "${var.cluster_name}"
  }
}

resource "google_compute_firewall" "cluster-ssh" {
  name    = "${var.name}-ssh"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.name}-ssh"]
}

resource "google_compute_firewall" "cluster" {
  name    = "${var.name}-cluster"
  network = "${var.network}"

  allow {
    protocol = "tcp"
    ports    = ["9200", "9300"]
  }

  source_tags = ["${var.cluster_name}"]
  target_tags = ["${var.name}"]
}
