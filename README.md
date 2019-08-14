[![Build Status](https://drone.techservices.illinois.edu/api/badges/techservicesillinois/terraform-aws-ssm-parameter/status.svg)](https://drone.techservices.illinois.edu/techservicesillinois/terraform-aws-ssm-parameter)

# ssm-parameter

Provides a list of AWS System Manager parameters, supporting
both secure and plain-text strings. **NOTE:** This module
allows creating and destroying parameters, and supports setting
descriptions and initial values. **By design, it does not permit
changing the value of existing SSM parameters.**
The underlying principles behind this design decision are:

* Secure strings should not be defined in a Terraform configuration in GitHub, where they can be freely perused. To enhance security, these parameters should be stored *only* in SSM itself.
* The same consideration doesn't apply to non-sensitive data stored in plaintext strings. However, the values associated with these parameters may vary between, say, development and production environments. As such, they are a poor choice for hardcoding into a Terraform configuration file, because the hardcoded value may be incorrect for one or more environment. It would be undesirable for existing environment-specific values set for a service implementation to be overwritten by Terraform.

Example Usage
-----------------

```hcl
module "ssm" {
  source = "git@github.com:techservicesillinois/terraform-ssm-parameter"

  name = "example"

  parameters = [
    {
    name        = "foo_db_endpoint"
    description = "Endpoint URL for foo database"
    },

    {
    name        = "foo_db_engine"
    description = "Engine for foo database"
    value       = "postgres"
    },

    {
    name        = "foo_db_password"
    description = "Password for foo database"
    type        = "SecureString"
    },
  ]
}
```

Argument Reference
-----------------

The following arguments are supported:

* `name` - (Required) The name of the service to which this parameter list belongs, e.g., `example`. The value is appended to the `prefix`.

* `parameter` - (Required) A [parameter](#parameter) block. Parameter blocks are documented below.

* `prefix` - (Optional) Prefix prepended to parameter name, and used to produce a hierarchical layout of parameters. Default: `/service`.

parameter
---------

A parameter block consists of a list of maps. Each map entry supports the following keys:

* `description` – (Optional) A description of the parameter. If not specified, a default value is assigned that draws attention to
a meaningful description.

* `name` – (Required) The parameter name.

* `type` – (Optional) The parameter's type. The values `String` and
`SecureString` are permissible, with `String` being the default.

* `prefix` – (Optional) A string prepended to the parameter name to allow hierarchical organization of SSM parameters. The default prefix is `/service`, which is sufficient for most use. However, there are cases where a different prefix is used, e.g., `/cloudwatch_to_splunk/service` for a parameter hierarchy managed separately from parameters specific to a single service.

* `value` – (Optional) The initial value for the parameter. **Note that
the value is used only on creation of the parameter. The parameter value is never overwritten by Terraform.**

#### Recommendations:

1. **Never use the `value` attribute for a parameter containing sensitive data. The reason is that sensitive strings should not reside in Terraform code stored in a Git repository, nor should they be stored in Terraform state. Instead, sensitive data can be defined securely using the Amazon SSM console.**

2. Specify a value for `description` for *all* parameters. This is not required, but the default description is an unsightly value that calls attention to the absence of a meaningful description.

3. Don't specify a value in cases where the value is strongly likely to vary between different environments. An example would be a database endpoint URL. The user might consider specifying a prototype string showing the format of a valid value. Alternatively, this detail can be provided in comments in the Terraform configuration.

Attributes Reference
--------------------

No attributes are exported.
