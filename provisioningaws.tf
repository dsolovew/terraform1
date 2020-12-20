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
    #!/bin/bash
    sudo apt update && sudo apt install nginx -y
  EOF
   count = 1
   tags = {
     Name = "Nginx"
     Environment = "Test"
   }
 }

resource "aws_key_pair" "ssh-key" {
  key_name = "ssh-key"
  public_key = "~/.ssh/id_rsa.pub"
}


#output "instance_ip" {
 # description = "The public ip for ssh access"
 # value = [aws_instance.nginx.public_ip]
#}