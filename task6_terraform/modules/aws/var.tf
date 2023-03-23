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

variable "ssh_key_path" {
  description = "sshkeypath"
  default = "C:\\Users\\95\\.ssh\\sshkey.pub"
  type = string
}