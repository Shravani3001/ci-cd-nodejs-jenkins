variable "region" {
    default = "us-east-1"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "key_name" {
    default = "ci-cd-nodejs-key"
}

variable "public_key_path" {
    default = "./ci-cd-nodejs-key.pub"
}

variable "availability_zone" {
    default = "us-east-1a"
}