#--- compute/variables.tf
variable "project_name" {
  description = "project name is used as resource tag"
  type        = string
}
variable "key_name" {
  description = "name of keypair to access ec2 instances"
  type        = string
}
variable "public_key_path" {
  description = "file path on deployment machine to public rsa key to access ec2 instances"
  type        = string
}
variable "vpc1_id" {
  description = "id of vpc1"
  type        = string
}
variable "subprv1_id" {
  description = "id of public subnets"
  type        = string
}
variable "sgprv1_id" {
  description = "id of security group"
  type        = string
}

variable "vpc2_id" {
  description = "id of vpc2"
  type        = string
}
variable "subpub1_id" {
  description = "id of public subnets"
  type        = string
}
variable "sgpub1_id" {
  description = "id of security group"
  type        = string
}
