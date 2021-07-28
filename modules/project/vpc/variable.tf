variable "vpc_cidr" {
    default="10.0.0.0/16"
  
}

variable "pub_sub1_cidr" {
      default="10.0.1.0/24"

}

variable "pub_sub2_cidr" {
      default="10.0.2.0/24"

}

variable "pri_sub1_cidr" {
      default="10.0.3.0/24"

}

variable "pri_sub2_cidr" {
      default="10.0.4.0/24"

}

variable route_to_internet {
      default = "0.0.0.0/0"
}

variable environment{
      default= "stage"
}