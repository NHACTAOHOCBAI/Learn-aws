variable "region" {
  type = string
  # default = "ap-southeast-1"
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "amis" {
  type = map(string)
  default = {
    "us-east-1"      = "ami-0e34b50e714a297f1"
    "ap-southeast-1" = "ami-01a09b6de1739f50a"
  }
}
