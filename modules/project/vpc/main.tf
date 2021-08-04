
#Created Igw
#Use   depends_on = [aws_internet_gateway.gw] if possible

resource "aws_internet_gateway" "Myigw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "myigw"
  }
}



# resource "aws_instance" "app" {
#   for_each      = data.aws_subnet_ids.example.ids
#   ami           = var.ami
#   instance_type = "t2.micro"
#   subnet_id     = each.value
# }

#Created VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

#Created Public Subnets
resource "aws_subnet" "first_public_subnet_c" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pub_sub1_cidr
  map_public_ip_on_launch =true
  availability_zone = "${var.aws_region}c"

  tags = {
    Name = "Public"
  }
}

resource "aws_subnet" "second_public_subnet_d" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pub_sub2_cidr
  availability_zone = "${var.aws_region}d"

    map_public_ip_on_launch =true

  tags = {
    Name = "public"
  }
}


#created Private subnets
resource "aws_subnet" "first_Private_subnet_a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pri_sub1_cidr
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "private"
  }
}

resource "aws_subnet" "second_private_subnet_b" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pri_sub2_cidr
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "private"
  }
}


#Created route table for public subnet

# resource "aws_route_table" "public-rt" {
#   vpc_id = aws_vpc.main.id
  
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.Myigw.id
#   }


#   tags = {
   
#     Environment = var.environment
#     CreatedBy = "Shridhar"
#   }

# }





#Created route tables

resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.route_to_internet
    gateway_id = aws_internet_gateway.Myigw.id
  }

  tags = {
    Name = "example"
  }
}
#=================================================
# Route Table Association for Public
#=================================================


resource "aws_route_table_association" "sec_pub_sub-rt-association" {
  subnet_id      = "${aws_subnet.second_public_subnet_d.id}"
  route_table_id = "${aws_route_table.PublicRT.id}"
}

resource "aws_route_table_association" "fir_pub_sub-rt-association" {
  subnet_id      = "${aws_subnet.first_public_subnet_c.id}"
  route_table_id = "${aws_route_table.PublicRT.id}"
}


