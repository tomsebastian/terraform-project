variable aws_reg {
  description = "This is aws region"
  default     = "us-east-2"
  type        = string
}

variable name {
  description = "this is name for tag"
  default     = "terraform"
}

variable environment {
  description = "this is name for tag"
  default     = "testing"
}

variable project {
  description = "this is name for tag"
  default     = "training"
}

variable ssh_key {
  default     = "~/.ssh/id_rsa.pub"
  description = "Default pub key"
}

variable ssh_priv_key {
  default     = "~/.ssh/aws-key.pem"
  description = "Default pub key"
}

variable vpc_cidr {
  description = "The CIDR block for the VPC."

  default     = "10.0.0.0/16"
}

variable availability_zones {
  default = ["us-east-2a", "us-east-2b", "us-east-2c"]

}
variable flag {
  default = true
}

