resource "aws_ssm_parameter" "default" {
  for_each = var.parameters
  #name       = each.key
  name        = format("%s/%s/%s", var.prefix, var.name, each.key)
  type        = lookup(each.value, "type", "String")
  value       = lookup(each.value, "value", "*** NO VALUE SET ***")
  description = lookup(each.value, "description", "*** NO DESCRIPTION SET ***")

  lifecycle {
    # Never update the value of an existing SSM parameter.
    ignore_changes = [value]
  }
}
