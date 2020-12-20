provider "aws" {
  region = "us-east-2"
 }

 resource "aws_security_group" "webssh" {
   name = "nginx_group"
   description = "Web security group"
   
   ingress  {
     description = "inbound web"
     cidr_blocks = [ "0.0.0.0/0" ]
     protocol = "tcp"
     from_port = 80
     to_port = 80
   } 
   
   ingress  {
     description = "inbound ssh"
     cidr_blocks = [ "0.0.0.0/0" ]
     protocol = "tcp"
     from_port = 22
     to_port = 22
   }

   egress  {
     description = "outbound"
     cidr_blocks = [ "0.0.0.0/0" ]
     protocol = "-1"
     from_port = 0
     to_port = 0
   }  
 }
 
 resource "aws_instance" "nginx" {
   ami = "ami-0dd9f0e7df0f0a138"
   instance_type = "t3.micro"
   vpc_security_group_ids  = [aws_security_group.webssh.id]
   key_name = "ssh-key"
   user_data = <<EOF
!# /bin/bash
sudo apt update && sudo apt install nginx -y
  EOF
   count = 1
   tags = {
     Name = "Nginx"
     Environment = "Test"
   }
 }

  resource "aws_instance" "nginx2" {
    ami = "ami-09558250a3419e7d0"
    instance_type = "t3.micro"
    vpc_security_group_ids  = [aws_security_group.webssh.id]
    key_name = "ssh-key"
    user_data = <<EOF
!# /bin/bash
sudo apt update && sudo apt install nginx -y
  EOF
    count = 1
    tags = {
     Name = "nginx2"
     Environment = "Test"
   }
 }

resource "aws_key_pair" "ssh-key" {
  key_name = "ssh-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC53chIerJq/+q6dXOSPjZyEQZvGTTOeIwzvY4UFQxFVEx6l4RaiO+ibSmTJSCVqPhYnHQCxGiMWkbm9SvLdOHe/GZuB4yIULRqyWNnn2G9iGxOYM2z6MX0SAa5zW1aRdKzxtTE9QetpBAATewvARC4wrxH8gl8oRRpdtDtD32xQMZ1rQ8x2nBD985yL5bvnwIzo+WgsWUpzNEbo/hwgpZPmX+bPRHFB5iaYdluDImQIL3QxmkfAuy63YWcx69FqNoDVa32Blv59+uG740Fqwy2U1bP7bFDBlr8tzjiN3ZORSnmF7yGRPYraF3SPk7nyEZHCBnHqtHYkSeeokQerWbL"
}
