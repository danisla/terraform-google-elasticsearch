# Elasticsearch Terraform Module

Terraform module for creating Elasticsearch nodes and various cluster topologies.

<img src="https://concourse-tf.gcp.solutions/api/v1/teams/main/pipelines/tf-es-regression/badge" />
        
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

### [multi-node-stateful](./examples/multi-node-stateful)

[![button](http://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/danisla/terraform-google-elasticsearch&page=editor&tutorial=examples/multi-node-stateful/README.md)

Similar example as the multi-node cluster deployment but with data nodes outside of a instance group manager.

![architecture diagram](https://raw.githubusercontent.com/danisla/terraform-google-elasticsearch/master/examples/multi-node/diagram.png)

## Module Best Practices

- Rebuild disk images using the [packer repository](https://github.com/danisla/elasticsearch-cloud-deploy/tree/gcp).
- Set `disk_auto_delete = false` in production to avoid losing data when instances are recreated.

### Scaling

In the [multi-node example](./examples/multi-node) each node tier can be scaled independently. When scaling _UP_, simply, increase the number of nodes using the `num_nodes` module variable. The new nodes will be created by the Regional Instance Group Manager and the index shards will self-balance.

### Upgrading

TBD

### Monitoring

TBD
 
