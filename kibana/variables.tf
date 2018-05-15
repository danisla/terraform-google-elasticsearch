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
  default     = "kibana-6"
}

variable "machine_type" {
  description = "The machine type for the instances."
  default     = "n1-standard-2"
}

variable "num_nodes" {
  description = "Number of nodes in the instance group."
  default     = 1
}

variable "name" {
  description = "Name of the instance"
  default     = "kibana"
}

variable "elasticsearch_url" {
  description = "URL of elasticsearch host"
}

variable "security_enabled" {
  description = "Enable xpack security"
  default     = "false"
}

variable "monitoring_enabled" {
  description = "Enable xpack monitoring"
  default     = "false"
}
