provider "aws" {
    region = var.region
}

data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "MainVPC"
    }
}

resource "aws_key_pair" "ci-cd-nodejs-key" {
    key_name = var.key_name
    public_key = file(var.public_key_path)
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "MainIGW"
    }
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true

    tags = {
        Name = "Public-Subnet"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "Public-Route"
    }
}

resource "aws_route_table_association" "public_assoc" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "ssh_sg" {
    name = "allow-ssh"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "ci-cd-nodejs-instance" {
    instance_type = var.instance_type
    key_name = aws_key_pair.ci-cd-nodejs-key.key_name
    ami = data.aws_ami.ubuntu.id
    vpc_security_group_ids = [aws_security_group.ssh_sg.id]
    subnet_id = aws_subnet.public.id
    associate_public_ip_address = true

    tags = {
        Name = "ci-cd-nodejs-instance"
    }
}