variable "project" {
  description = "The project to deploy to, if not set the default provider project is used."
  default     = ""
}

variable "region" {
  default = "us-central1"
}

variable "zones" {
  description = "Which zones to deloy instances to."
  type        = "list"
}

variable "network_cidr" {
  default = "10.127.0.0/20"
}

variable "network" {
  description = "The network to deploy to"
  default     = "default"
}

variable "network_project" {
  description = "Name of the project for the network. Useful for shared VPC. Default is var.project."
  default     = ""
}

variable "subnetwork" {
  description = "The subnetwork to deploy to"
  default     = "default"
}

variable "machine_type" {
  description = "In the form of custom-CPUS-MEM, number of CPUs and memory for custom machine. https://cloud.google.com/compute/docs/instances/creating-instance-with-custom-machine-type#specifications"
  default     = "custom-6-65536-ext"
}

variable "min_cpu_platform" {
  description = "Specifies a minimum CPU platform for the VM instance. Applicable values are the friendly names of CPU platforms, such as Intel Haswell or Intel Skylake. https://cloud.google.com/compute/docs/instances/specify-min-cpu-platform"
  default     = "Automatic"
}

variable "name" {
  description = "Name of the node"
  default     = "elasticsearch"
}

variable "num_nodes" {
  description = "Number of nodes to create"
  default     = 1
}

variable "boot_image_family" {
  description = "Disk image family to use."
  default     = "elasticsearch-6"
}

variable "boot_image_project" {
  description = "Disk image project, if different than provider default project."
  default     = ""
}

variable "boot_image_url" {
  default = ""
}

variable "boot_disk_auto_delete" {
  description = "Whether or not the disk should be auto-deleted."
  default     = true
}

variable "boot_disk_type" {
  description = "The GCE disk type. Can be either pd-ssd, local-ssd, or pd-standard."
  default     = "pd-ssd"
}

variable "startup_script" {
  default = ""
}

variable "boot_disk_size_gb" {
  description = "The size of the image in gigabytes."
  default     = 10
}

variable "access_config" {
  description = "The access config block for the instances. Set to [{}] for ephemeral external IP."
  type        = "list"
  default     = []
}

variable "network_ip" {
  description = "Set the network IP of the instance. Useful only when num_nodes is equal to 1."
  default     = ""
}

variable "node_tags" {
  description = "Additional compute instance network tags for the nodes."
  type        = "list"
  default     = []
}

variable "metadata" {
  description = "Map of metadata values to pass to instances."
  type        = "map"
  default     = {}
}

variable "depends_id" {
  description = "The ID of a resource that the instance group depends on."
  default     = ""
}

variable "service_account_email" {
  description = "The email of the service account for the instance template."
  default     = ""
}

variable "service_account_scopes" {
  description = "List of scopes for the instance template service account"
  type        = "list"

  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/devstorage.full_control",
  ]
}

variable "attached_disk_1" {
  description = "First attached disk"
  type        = "map"
  default     = {
    size = 50
    type = "pd-standard"
  }
}

variable "attached_disk_2" {
  description = "Second attached disk"
  type        = "map"
  default     = {
    size = 50
    type = "pd-standard"
  }
}

variable "attached_disk_3" {
  description = "Third attached disk"
  type        = "map"
  default     = {
    size = 50
    type = "pd-standard"
  }
}

variable "attached_disk_4" {
  description = "Fourth attached disk"
  type        = "map"
  default     = {
    size = 50
    type = "pd-standard"
  }
}

variable "cluster_name" {
  description = "Name of the elasticsearch cluster, used in node discovery"
  default     = "elasticsearch"
}

variable "elasticsearch_logs_dir" {
  description = "Directory for node logs"
  default     = "/var/log/elasticsearch"
}

variable "heap_size" {
  description = "Heap size, should be half of the node memory up to 31g"
  default     = "2g"
}

variable "security_enabled" {
  description = "Enable xpack security"
  default     = "false"
}

variable "monitoring_enabled" {
  description = "Enable xpack monitoring"
  default     = "false"
}

variable "masters_count" {
  description = "Number of dedicated master nodes in the cluster, used for setting minimum master nodes."
  default     = 0
}

variable "master_node" {
  description = "Node functions as master node"
  default     = true
}

variable "data_node" {
  description = "Node functions as data node"
  default     = true
}

variable "ingest_node" {
  description = "Node functions as ingest node"
  default     = false
}

variable "http_enabled" {
  description = "http is enabled on the node"
  default     = true
}
