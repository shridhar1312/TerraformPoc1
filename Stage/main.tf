

module "vpc" {
  source = "../modules/project/vpc"
}

module "sg" {
    source = "../modules/project/sg"
    vpc_id = module.vpc.cust_vpc_id
}

module "ec2" {
  source= "../modules/project/ec2"
  vpc_security_group_ids = "${[module.sg.allow_http_ssh]}"
  subnet_id = "${module.vpc.second_public_subnet_d}"
}


module "alb" {
  source = "../modules/project/alb"
  vpc_id = module.vpc.cust_vpc_id
  security_groups =  ["${module.sg.allow_http_ssh}"]
  subnets = ["${module.vpc.first_public_subnet_c}","${module.vpc.second_public_subnet_d}"]
  instance_wo_asg = module.ec2.ec2_wo_asg
}

module "asg" {
  source = "../modules/project/asg"
  vpc_zone_identifier= ["${module.vpc.first_public_subnet_c}","${module.vpc.second_public_subnet_d}"]
  security_groups = "${module.sg.allow_http_ssh}"
  alb_target_group_arn = "${module.alb.target_group_arn}"
}
