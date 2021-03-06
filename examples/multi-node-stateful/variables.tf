variable "cluster_name" {
  default = "tf-es-cluster"
}

variable "region" {
  default = "us-central1"
}

variable "zones" {
  type    = "list"
  default = ["us-central1-a", "us-central1-b", "us-central1-c"]
}

variable "network_name" {
  default = "tf-es-cluster"
}

// Master nodes
variable "master_machine_type" {
  default = "n1-standard-1"
}

variable "master_heap_size" {
  default = "2g"
}

variable "master_num_nodes" {
  default = 3
}

// Data nodes
variable "data_machine_type" {
  default = "n1-standard-4"
}

variable "data_heap_size" {
  default = "7g"
}

variable "data_num_nodes" {
  default = 5
}

variable "attached_disk_1" {
  type = "map"

  default = {
    size = 50
    type = "pd-standard"
  }
}

variable "attached_disk_2" {
  type = "map"

  default = {
    size = 50
    type = "pd-standard"
  }
}

variable "attached_disk_3" {
  type = "map"

  default = {
    size = 50
    type = "pd-standard"
  }
}

variable "attached_disk_4" {
  type = "map"

  default = {
    size = 50
    type = "pd-standard"
  }
}

// Client nodes
variable "client_machine_type" {
  default = "n1-standard-1"
}

variable "client_heap_size" {
  default = "2g"
}

variable "client_num_nodes" {
  default = 2
}

// Indexing nodes
variable "indexing_machine_type" {
  default = "n1-highcpu-4"
}

variable "indexing_heap_size" {
  default = "2g"
}

variable "indexing_num_nodes" {
  default = 2
}

// Bastion host
variable "bastion_image_family" {
  default = "centos-7"
}

variable "bastion_image_project" {
  default = "centos-cloud"
}

variable "bastion_image_url" {
  default = ""
}

variable "bastion_machine_type" {
  default = "n1-standard-4"
}

variable "bastion_disk_size" {
  default = 256
}

variable "bastion_disk_type" {
  default = "pd-ssd"
}
