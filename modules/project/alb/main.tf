
# data "aws_subnet_ids" "public" { 
#   vpc_id = var.vpc_id
#  tags = { Name = "public" } 
# } 

resource "aws_lb" "shri_lb" {
  name               = "shri-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups = var.security_groups #Add it from env
  subnets = var.subnets         #Add it from env

  enable_deletion_protection = false

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.bucket
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    Environment = "production"
  }
}

#  ALB Listener 
# ---------------------------------------------------------
############## listner and listener rules for external HTTP

resource "aws_lb_listener" "shri_lb" {
  load_balancer_arn = aws_lb.shri_lb.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.shri_tglb.arn
  }
}


resource "aws_lb_target_group" "shri_tglb" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id  
}


###########  Associating Load balancer with instances ############## 

# resource "aws_lb_target_group_attachment" "test" {
#   target_group_arn = aws_lb_target_group.shri_tglb.arn
#   target_id        = var.instance_wo_asg
#   port             = 80
# }






