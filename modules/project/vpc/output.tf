

output "cust_vpc_id" {
  value = aws_vpc.main.id
}

output "second_public_subnet_d"{
  value = aws_subnet.second_public_subnet_d.id
}

output "first_public_subnet_c"{
  value = aws_subnet.first_public_subnet_c.id
}



