variable aws_reg {
  description = "This is aws region"
  default     = "eu-west-2"
  type        = string
}

variable stack {
  description = "this is name for tags"
  default     = "terraform"
}

variable ssh_key {
  default     = "~/.ssh/id_rsa.pub"
  description = "Default pub key"
}

variable ssh_priv_key {
  default     = "~/.ssh/aws-key.pem"
  description = "Default pub key"
}