resource "aws_ssm_parameter" "default" {
  count       = "${length(var.parameters)}"
  description = "${lookup(var.parameters[count.index], "description", "*** NO DESCRIPTION SET ***")}"
  name        = "${format("%s/%s/%s", var.prefix, var.name, lookup(var.parameters[count.index], "name"))}"
  type        = "${lookup(var.parameters[count.index], "type", "String")}"
  value       = "${lookup(var.parameters[count.index], "value", "*** NO VALUE SET ***")}"

  lifecycle {
    # Never update the value of an existing SSM parameter.
    ignore_changes = [
      "value",
    ]
  }
}

variable "parameters" {
  description = "Parameters expressed as a list of maps, each entry of which may contain the following keys: description, name, type, and value."
  default     = []
}

variable "name" {
  description = "Parameter name"
}

variable "prefix" {
  description = "Prefix prepended to parameter name if not using default"
  default     = "/service"
}
