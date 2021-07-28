

output "cust_vpc_id" {
  value = aws_vpc.main.id
}

output "second_public_subnet"{
  value = aws_subnet.second_public_subnet.id
}




