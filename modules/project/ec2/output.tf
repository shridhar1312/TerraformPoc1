output ec2_public_ip{
    value= aws_instance.Myec2.public_ip
}

output "ec2_wo_asg" {
  value = aws_instance.Myec2.id
}



