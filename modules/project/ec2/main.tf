#===================================================
# dynamic value of aws ami through data sources
#===================================================
data "aws_ami" "ubuntu" {

    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"]
}

#======================
# Instance Creation
#======================
resource "aws_instance" "Myec2" {

  #ami     = "ami-09e67e426f25ce0d7"
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.ec2_key_name
  monitoring = true
  root_block_device {
    encrypted = false
  }
vpc_security_group_ids =var.vpc_security_group_ids
subnet_id = var.subnet_id

  user_data = <<EOF
#!/bin/bash
apt-get update
apt-get install -y apache2
echo "Welcome to my website" > index.html cp index.html /var/www/html

EOF
  tags = {
    
    CreatedBy = "shridhar"
    auto-start-stop = "True"
  }

  lifecycle {
    ignore_changes = [
      user_data,
    ]
    prevent_destroy = false
  }
}


