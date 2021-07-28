

module "vpc" {
  source = "../modules/project/vpc"
}

module "sg" {
    source = "../modules/project/sg"
    vpc_id = module.vpc.cust_vpc_id


}

module "ec2"{
  source= "../modules/project/ec2"
  vpc_security_group_ids = "${[module.sg.allow_http_ssh]}"
  subnet_id = "${module.vpc.second_public_subnet}"
}


