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

resource ibm_function_namespace namespace {
  name              = "${var.function_namespace}" #var.function_namespace
  description       = "Expand 2020"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
  #resource_group_id = data.ibm_resource_group.resource_group.id
}
resource ibm_function_package package {
  name      = "${var.function_package_name}" #var.function_package_name
    namespace = "${var.function_namespace}"
  #namespace = "${ibm_function_namespace.namespace.name}"
}
resource ibm_function_action hello_action {
  name      = "${var.function_package_name}/hello-${var.environment}"
  #namespace = "${ibm_function_namespace.namespace.name}"
  namespace = "${var.function_namespace}"
  exec {
    kind = "nodejs:10"
    code = "${file("src/index.js")}"
  }
  user_defined_parameters = <<EOF
        [
    {
        "key":"environment",
        "value":"${var.environment}"
    }
        ]
EOF
}
