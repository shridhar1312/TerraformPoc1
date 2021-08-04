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

# data "template_file" "apache" {
#   template = <<EOF
#         #!/bin/bash
#         apt-get update
#         apt-get install -y apache2
#         echo "Welcome to my website" > index.html cp index.html /var/www/html

# EOF
# }

# resource "aws_launch_configuration" "poc-lc" {
#   name_prefix   = "terraform-lc-shriexample"
#   image_id      = "${data.aws_ami.ubuntu.id}"
#   instance_type = "t2.micro"
#   security_groups = [var.security_groups]

#   lifecycle {
#     create_before_destroy = true
#   }
  
#    user_data = <<EOF
#         #!/bin/bash
#         apt-get update
#         apt-get install -y apache2
#         echo "Welcome to my website" > index.html cp index.html /var/www/html

# EOF
# }

resource "aws_launch_template" "shrilt" {

  
 name_prefix   = "terraform-lc-shriexample-"
  image_id      = "ami-0516172c0d32be771"
  instance_type = "t2.micro"

  instance_initiated_shutdown_behavior = "terminate"
  key_name = "ASG"
  monitoring {
    enabled = true
  }
      vpc_security_group_ids = [var.security_groups]

lifecycle {
    create_before_destroy = true
  }

 # user_data = "${data.template_file.apache.rendered}"
  #user_data = "${base64encode(example.sh))}"
    #user_data = filebase64("${path.module}/example.sh")
    #path= "./example.sh"
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "test"
    }
  }

}

resource "aws_autoscaling_group" "pocasg" {
  name                 = "terraform-asg-shri-example"
  min_size             = 2
  max_size             = 3
  vpc_zone_identifier = var.vpc_zone_identifier
  
  depends_on = [aws_launch_template.shrilt]

  launch_template {
    id      = aws_launch_template.shrilt.id
    version = "$Latest"
  }
  #target_group_arns         = ["${aws_lb_target_group.CF2TF-TargetGroup.arn}"]
  # target_group_arns = var.target_group_arns
  lifecycle {
    create_before_destroy = true
    #ignore_changes = [load_balancers, target_group_arns]

  }
}

# #Added for lb attachment
# resource "aws_autoscaling_attachment" "asg_attachment_withalb" {
#   autoscaling_group_name = aws_autoscaling_group.poc-asg.id
#   #elb                    = aws_lb.test.id
#   elb = var.elbid             #Add it from module
# }

resource "aws_autoscaling_attachment" "asg_attachment_elb" {
  autoscaling_group_name = aws_autoscaling_group.pocasg.id
  #alb_target_group_arn = aws_lb_target_group.MyWPInstancesTG.arn
  alb_target_group_arn = var.alb_target_group_arn
}

