## Ingress and Egress with the same IP on Azure

This repository is meant as an example to create an aks cluster where ingress and egress share the same ip.

# Preparation

## Create secrets folder

We are going to deploy an ssh key with our cluster, so let's create one: 

mkdir -p ../secrets/ssh/aks-prod-sshkeys-terraform

## Create SSH Key

ssh-keygen \
    -m PEM \
    -t rsa \
    -b 4096 \
    -C "azureuser@myserver" \
    -f ../secrets/ssh/aks-prod-sshkeys-terraform/aksprodsshkey \
    -N QDewtgsg4gsdf3

# Create your state storage and cluster


## Create Azure Storage Account in different Resource Group

You should store your terraform state in a different resource group then your cluster, this way it will be independent of each other but still able to complement one another.
In order to achieve this I create an extra terraform project, just for our state storage in /terraform_state.
To execute the project:

´´´´
$ cd ./terraform_state
$ terraform apply
´´´´


## Create your cluster


´´´´
$ cd ./terraform_state
$ terraform apply
´´´´

after the playbook has run where are ready to go and to retrieve our kubernetes config with:

´´´
az aks get-credentials --resource-group terraform-aks-dev --name terraform-aks-dev-cluster
´´´ 

## Get the ip of your ingress load balancer

retrieve the ip of your kubernetes api load balancer.

( I have not found a sophisticated command for that yet and use the portal).

## Assign that ip to your service

Azure will give you a load balancer to access your cluster and we retrieved its ip in the previous steps.
This IP can be assigned directly to your load balancer using the ***loadBalancerIP:*** Annotation.

Once you modify your service with the right ip, the service will be ready for service. 
In Combination with setting your outbound_type to "loadBalancer" in the terraform aks manifests, you will now have ingress and egress for the same IP.

```
loadBalancerIP: xx.xx.xx.xx
```

more about it can be found here: <https://kubernetes.io/docs/concepts/services-networking/service/>