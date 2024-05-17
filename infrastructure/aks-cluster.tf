provider "azurerm" {
  features {}
}

variable "serviceprincipalid" {
  type    = string
  default = "#{Azure.ServicePrincipal.Id}"
}

variable "serviceprincipalpassword" {
  type    = string
  default = "#{Azure.ServicePrincipal.Password}"
}

variable "octopusapikey" {
  type    = string
  default = "#{Octopus.API.Key}"
}


resource "azurerm_resource_group" "default" {
  name     = "demo.octopus.kubernetes"
  location = "UK South"

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = "demo-octopus-kubernetes-aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "demo-octopus-kubernetes-aks-dns"
  kubernetes_version  = "1.27.7"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.serviceprincipalid
    client_secret = var.serviceprincipalpassword
  }
}

data "azurerm_kubernetes_cluster" "credentials" {
  name                = azurerm_kubernetes_cluster.default.name
  resource_group_name = azurerm_resource_group.default.name
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.credentials.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.credentials.kube_config.0.cluster_ca_certificate)
  }
}

resource "helm_release" "csi_driver_nfs" {
  name       = "csi-driver-nfs"
  namespace  = "kube-system"
  repository = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts"
  chart      = "csi-driver-nfs"
  version    = "v4.6.0"
  atomic     = true
  create_namespace = true
}

resource "helm_release" "octopus_agent_democluster" {
  name = "democluster"
  namespace = "octopus-agent-democluster"
  repository = "oci://registry-1.docker.io"
  chart = "octopusdeploy/kubernetes-agent"
  create_namespace = true
  atomic = true
  
  set {
    name = "agent.acceptEula"
    value = "Y"
  }
  set {
    name = "agent.targetName"
    value = "Demo Cluster"
  }
  set {
    name = "agent.serverUrl"
    value = "https://demo.octopus.app/"
  }
  set {
    name = "agent.serverCommsAddress"
    value = "https://polling.demo.octopus.app/"
  }
  set {
    name = "agent.space"
    value = "Retail Tech"
  }
  set {
    name = "agent.targetEnvironments"
    value = "{development,test,production}"
  }
  set {
    name = "agent.targetRoles"
    value = "{demo-k8s-cluster}"
  }
  set {
    name = "agent.bearerToken"
    value = "eyJhbGciOiJQUzI1NiIsImtpZCI6IjVlYTRhN2RkZDYyMzRiNmNhOTA1NTNlZmNmNTgyZjgzIiwidHlwIjoiSldUIn0.eyJzdWIiOiIwZWViNjRjNS0yOGI5LTRlZDktOTczNi03MGY0YjZkNDRlNjgiLCJqdGkiOiJjYjdhMDJmZjY4NDI0N2Y2YTk0YjhmYzYxZTgxNjNmMSIsImF1ZCI6Imh0dHBzOi8vZGVtby5vY3RvcHVzLmFwcCIsImV4cCI6MTcxNDc1MjAzNSwiaXNzIjoiaHR0cHM6Ly9kZW1vLm9jdG9wdXMuYXBwIiwiaWF0IjoxNzE0NzQ4NDM1LCJuYmYiOjE3MTQ3NDg0MzV9.bpSj8Xgmht-o6fsD6R4lPh2sfSyz9sjsthSy5HJtnmNys_TAYpgcCyPCksWadGOT4qMvqeHm_NjHv1vZrdxQ9skfpm9smd-xqCVYdyD9NeTLDaiR3Ujg3SS_AqLeZz3wUtL9QQpV8I01jfN3fS3gp8AJg43IXwSrKk3TbGMcHyi1cx1g7T2sYT1hGNKb7fL-YagJFlwMERNMfDzwfZZKVocuAJqlx38fH0NAZbs5EO_dcK9TzhKALtIzymw5fWZ-0gHxz2x5uy43USouljAoEC9RE1PHcgD_ANxvN9b958pATNr7oJ0hSrI7HCItIgLwbpr54YHNgiL_Q95uuV2oeA"
  }

  set {
    name = "agent.serverApiKey"
    value = var.octopusapikey
  }
depends_on = [helm_release.csi_driver_nfs]
}