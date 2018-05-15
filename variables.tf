variable "project" {
  description = "The project to deploy to, if not set the default provider project is used."
  default     = ""
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

variable "access_config" {
  description = "The access config block for the instances. Set to [] to remove external IP."
  type        = "list"
  default     = [{}]
}

variable "network_ip" {
  description = "Set the internal IP of the node (single instance only)"
  default     = ""
}

variable "node_tags" {
  description = "Additional compute instance network tags for the nodes."
  type        = "list"
  default     = []
}

variable "region" {
  description = "The region to create the node instance in."
}

variable "zones" {
  description = "Which zones to deloy instances to."
  type        = "list"
}

variable "image_family" {
  description = "Disk image family to use."
  default     = "elasticsearch-6"
}

variable "image_project" {
  description = "Disk image project, if different than provider default project."
  default     = ""
}

variable "machine_type" {
  description = "The machine type for the instances."
  default     = "n1-standard-1"
}

variable "num_nodes" {
  description = "Number of nodes in the instance group."
  default     = 1
}

variable "name" {
  description = "Name of the node"
  default     = "elasticsearch"
}

variable "cluster_name" {
  description = "Name of the elasticsearch cluster, used in node discovery"
  default     = "elasticsearch"
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

variable "disk_auto_delete" {
  description = "Whether or not the disk should be auto-deleted, should not be used in production."
  default     = true
}

variable "disk_type" {
  description = "The GCE disk type. Can be either pd-ssd, local-ssd, or pd-standard."
  default     = "pd-ssd"
}

variable "disk_size_gb" {
  description = "The size of the disk in gigabytes. If not specified, it will inherit the size of its base image."
  default     = 0
}

variable "elasticsearch_data_dir" {
  description = "Path on the persistent disk for data."
  default     = "/opt/elasticsearch/data"
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
