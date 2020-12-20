provider "aws" {
  region = "us-east-2"
 }

 resource "aws_security_group" "web_ssh" {
   name = "nginx_group"
   description = "Web security group"
   count = 1

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
   vpc_security_group_ids  = [aws_security_group.web_ssh.id]
   user_data = file("nginx_provisioning.sh")
   count = 1
   tags = {
     Name = "Nginx"
     Environment = "Test"
   }
 }