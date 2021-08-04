


#    1. Error: Invalid value for module argument
# │ 
# │   on main.tf line 23, in module "asg":
# │   23:   security_groups = "${module.sg.allow_http_ssh}"
# │ 
# │ The given value is not suitable for child module variable "security_groups" defined at
# │ ../modules/project/asg/variable.tf:6,1-27: list of any single type required.
  #-->Removed type as list in variable

#   2.Error: Incorrect attribute value type
# │ 
# │   on ../modules/project/asg/main.tf line 25, in resource "aws_launch_configuration" "poc-lc":
# │   25:   security_groups = var.security_groups
# │     ├────────────────
# │     │ var.security_groups is "sg-0e57260ef21875929"
# │ 
# │ Inappropriate value for attribute "security_groups": set of string required.

 #Put var.security_group in alb  ---> put bracket in env ["${module.sg.allow_http_ssh}"]



# 3.Error: Error creating Auto Scaling Group: ValidationError: Launch configuration name not found - A launch configuration with the name: terraform-lc-shriexample20210728180109660800000001 does not exist
# │       status code: 400, request id: 76a58785-bfe7-4f43-85cc-26c2782e78e2
# │ 
# │   with module.asg.aws_autoscaling_group.poc-asg,
# │   on ../modules/project/asg/main.tf line 88, in resource "aws_autoscaling_group" "poc-asg":
# │   88: resource "aws_autoscaling_group" "poc-asg" {
# │ 
# ╵

# 4. Can we use this in ?
#    vpc_zone_identifier = ["${data.aws_subnet.private.*.id}"]

# 5.My Launch template was not taking latest changes after including $latest too
# Resolution:-
# it doesn't change the running instances in asg, you need take them down one by one. After new instances up running, they get the latest setting. It will be useful when you work in prod environment. – BMW Jul 10 '18 at 1:41 

# https://stackoverflow.com/questions/51250943/terraform-provider-aws-auto-scaling-group-doesnt-take-effect-on-a-launch-te

# 6.Was getting key not exist error in ASG when new instances are being launch
# Changed name of key from ASG.pem to ASG in lt terraform conf

# 7.Error: Invalid function argument
# │ 
# │   on ../modules/project/asg/main.tf line 77, in resource "aws_launch_template" "shrilt":
# │   77:     user_data = filebase64("./example.sh")
# │ 
# │ Invalid value for "path" parameter: no file exists at ./example.sh; this function works only with files that are distributed
# │ as part of the configuration source code, so if this file will be created by a resource in this configuration you must instead
# │ obtain this result from an attribute of that resource.



# 8. Userdata is not running so see cloud_init.logs
#Looking in /var/log/cloud-init-output.log saved me as well.
# Alternative to userdata:-
# https://stackoverflow.com/questions/47713519/issue-using-terraform-ec2-userdata?rq=1


# For Alb:-

# 9. Error: Incorrect attribute value type
# │ 
# │   on ../modules/project/alb/main.tf line 8, in resource "aws_lb" "shri_lb":
# │    8:   subnets = var.subnet                   #Add it from env
# │     ├────────────────
# │     │ var.subnet is a string, known only after apply
# │ 
# │ Inappropriate value for attribute "subnets": set of string required.

# 10.Error: Incorrect attribute value type
# │ 
# │   on ../modules/project/alb/main.tf line 7, in resource "aws_lb" "shri_lb":
# │    7:   security_groups = [var.security_groups]  #Add it from env
# │     ├────────────────
# │     │ var.security_groups is tuple with 2 elements
# │ 
# │ Inappropriate value for attribute "security_groups": element 0: string required.
# ╵
# ╷

# 11. Error: error creating application Load Balancer: InvalidConfigurationRequest: 
# A load balancer cannot be attached to multiple subnets in the same Availability Zone
# │       status code: 400, request id: 2037ccf0-24e0-47db-9534-5562dcecf075
# │ 
# │   with module.alb.aws_lb.shri_lb,
# │   on ../modules/project/alb/main.tf line 3, in resource "aws_lb" "shri_lb":
# │    3: resource "aws_lb" "shri_lb" {
# │ 

# ===>Added Az in subnets

# 12.Error: error creating subnet: InvalidSubnet.Conflict: The CIDR '10.0.3.0/24' conflicts with another subnet
# │       status code: 400, request id: 4bd92624-3170-4202-aaea-e71d70183845
# │ 
# │   with module.vpc.aws_subnet.first_Private_subnet_a,
# │   on ../modules/project/vpc/main.tf line 58, in resource "aws_subnet" "first_Private_subnet_a":
# │   58: resource "aws_subnet" "first_Private_subnet_a" {
# │ 
# ╵
# ╷
# │ 13. Error: error creating subnet: InvalidSubnet.Conflict: The CIDR '10.0.4.0/24' conflicts with another subnet
# │       status code: 400, request id: 2e929eb3-d319-4893-9c0c-a34b3831b24b
# │ 
# │   with module.vpc.aws_subnet.second_private_subnet_b,
# │   on ../modules/project/vpc/main.tf line 68, in resource "aws_subnet" "second_private_subnet_b":
# │   68: resource "aws_subnet" "second_private_subnet_b" {
# │====>destroyed infra and created again

# 14. 503 Service Temporarily Unavailable


# How to register  instances created by asg into target group and also newly created one

# https://stackoverflow.com/questions/50677641/add-asg-instances-in-target-group-via-terraform

#15.Error: Error updating Load Balancers Target Groups for Auto Scaling Group (terraform-asg-shri-example), 
# Please ensure they exist and try again.

# https://stackoverflow.com/questions/62558731/attaching-application-load-balancer-to-auto-scaling-group-in-terraform-gives

#16 How to add dependency between asg anf alb alb first and then asg

Use dependon flag