
variable "ami_id" {
  type        = string
  description = "Id de l'AMI de l'instance"
  default     = "ami-084568db4383264d4"
}

variable "instance_type" {
  type        = string
  description = "Type de l'instance EC2"
  default     = "t2.micro"
}

variable "mydomains" {
  type        = list(string)
  description = "mydomains"
  default     = ["x", "y", "z"]
}
variable "duckdns_token" {
  type        = string
  description = "your duckdns token"
  default     = "free token"

}


resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  count             = length(var.public_subnet_cidrs)
  subnet_id                   = element(aws_subnet.public_subnets[*].id,count.index)
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.http_access.id, aws_security_group.ssh_access.id,aws_security_group.https_access.id]
  
  key_name = aws_key_pair.tp4_key.key_name

  tags = {
    Name = "web-server"
  }
  #debug : tail -f /var/log/cloud-init-output.log
  user_data = templatefile("${path.module}/user-data.sh",{
    
    MY_DOMAIN=element(var.mydomains,count.index),
    ENTRYPOINT="websecure",
    DUCKDNS_TOKEN=var.duckdns_token,
    
    })

}

