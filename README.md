# Elasticsearch Terraform Module

Terraform module for creating Elasticsearch nodes and various cluster topologies.

## Usage

```ruby
module "es" {
  source       = "git::https://github.com/danisla/terraform-google-elasticsearch.git?ref=v1.0.0"
  name         = "es-single-node"
  region       = "us-central1"
  zones        = ["us-central1-f"]
  machine_type = "n1-standard-1"
  heap_size    = "2g"
  master_node  = true
  data_node    = true
  disk_size_gb = 50
}
```

## Examples

### [single-node](./examples/single-node)

[![button](http://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/danisla/terraform-google-elasticsearch&page=editor&tutorial=examples/single-node/README.md)

Example single node cluster deployment.

![architecture diagram](https://raw.githubusercontent.com/danisla/terraform-google-elasticsearch/master/examples/single-node/diagram.png)

### [multi-node](./examples/multi-node)

[![button](http://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/danisla/terraform-google-elasticsearch&page=editor&tutorial=examples/multi-node/README.md)

Example multi-node cluster deployment

![architecture diagram](https://raw.githubusercontent.com/danisla/terraform-google-elasticsearch/master/examples/multi-node/diagram.png)

## Module Best Practices

- Rebuild disk images using the [packer repository](https://github.com/danisla/elasticsearch-cloud-deploy/tree/gcp).
- Set `disk_auto_delete = false` in production to avoid losing data when instances are recreated.