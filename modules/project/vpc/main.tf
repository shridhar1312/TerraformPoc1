
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

#Created Subnets
resource "aws_subnet" "first_public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pub_sub1_cidr
    map_public_ip_on_launch =true

  tags = {
    Name = "Public1"
  }
}

resource "aws_subnet" "second_public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pub_sub2_cidr

    map_public_ip_on_launch =true

  tags = {
    Name = "public2"
  }
}


resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Myigw.id
  }


  tags = {
   
    Environment = var.environment
    CreatedBy = "Shridhar"
  }

}


#=================================================
#Creating 2 Public/Web LB Route Table Association
#=================================================


resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = "${aws_subnet.second_public_subnet.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}




resource "aws_subnet" "first_Private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pri_sub1_cidr

  tags = {
    Name = "private1"
  }
}

resource "aws_subnet" "second_private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pri_sub2_cidr

  tags = {
    Name = "private2"
  }
}

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


