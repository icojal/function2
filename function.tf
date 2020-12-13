resource "ibm_function_action" "nodehello" {
  name      = "action-name"
  namespace = "function-namespace-name"

  exec {
    kind = "nodejs:6"
    code = file("hellonode.js")
  }
}
