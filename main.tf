resource "aws_ssm_parameter" "default" {
  count = length(var.parameters)

  description = lookup(
    var.parameters[count.index],
    "description",
    "*** NO DESCRIPTION SET ***",
  )

  name = format(
    "%s/%s/%s",
    var.prefix,
    var.name,
    var.parameters[count.index]["name"],
  )

  type  = lookup(var.parameters[count.index], "type", "String")
  value = lookup(var.parameters[count.index], "value", "*** NO VALUE SET ***")

  lifecycle {
    # Never update the value of an existing SSM parameter.
    ignore_changes = [value]
  }
}
