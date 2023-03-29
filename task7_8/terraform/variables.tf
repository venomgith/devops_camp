variable "region" {
  description = "region user in AWS"
  type        = string
  default     = "us-east-1"
}

variable "ami" {
  description = "ami value"
  type        = string
  default     = "ami-09cd747c78a9add63"
}

variable "tags" {
  type = map(string)
  default = {
    "Terraform" = "TRUE",
    "Owner"     = "Ellington"
  }
}