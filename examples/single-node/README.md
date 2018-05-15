# Single node Elasticsearch

This example creates a single node Elasticsearch cluster.

**Figure 1.** *diagram of Google Cloud resources*

![architecture diagram](./diagram.png)

## Install Terraform

Install Terraform on Linux if it is not already installed (visit [terraform.io](https://terraform.io) for other distributions):

```
curl -sL https://goo.gl/UYp3WG | bash
source ${HOME}/.bashrc
```

## Setup Environment

```
cd examples/single-node
```

Set the project, replace `YOUR_PROJECT` with your project ID:

```
gcloud config set project YOUR_PROJECT
```

```
test -z DEVSHELL_GCLOUD_CONFIG && gcloud auth application-default login
export GOOGLE_PROJECT=$(gcloud config get-value project)
```

## Testing

SSH into the Kibana host with port forwarding to Cerebro and Kibana:

```
eval $(ssh-agent)
ssh-add ~/.ssh/google_compute_engine
eval $(terraform output kibana)
```

Open a local browser to view Cerebro and Kibana:

`walkthrough spotlight-pointer devshell-web-preview-button "Open Web Preview and change port to 9000"`

`walkthrough spotlight-pointer devshell-web-preview-button "Open Web Preview and change port to 5601"`

## Run Terraform

```
terraform init
terraform plan
terraform apply
```

## Cleanup

Exit the ssh session:

```
exit
```

Remove all resources created by terraform:

```
terraform destroy
```