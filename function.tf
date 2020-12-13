##############################################################################
# IBM Cloud Provider
##############################################################################

provider ibm {
  ibmcloud_api_key      = "${var.ibmcloud_apikey}"
  region                = "${var.ibm_region}"
  generation            = 1
  ibmcloud_timeout      = 60
}

##############################################################################


##############################################################################
# Resource Group
##############################################################################

data ibm_resource_group resource_group {
  name = "${var.resource_group}"
}

##############################################################################

resource ibm_function_action nodehello {
  name      = "action-name"
  namespace = "function-namespace-name"

 # exec {
  #  kind = "nodejs:6"
  #  code = file("index.js")
  #}
}
