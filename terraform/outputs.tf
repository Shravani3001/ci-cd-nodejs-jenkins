output "instance_public_ip" {
    value = aws_instance.ci-cd-nodejs-instance.public_ip
}