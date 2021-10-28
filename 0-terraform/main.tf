module "moduleK8s" {
    source = "./module/k8s-ec2/"

vpc_id		= var.vpc_id
name_subnets	= var.name_subnets
ami             = var.ami
ec2Type_proxy   = var.ec2Type_proxy
ec2Type_master  = var.ec2Type_master
ec2Type_workers = var.ec2Type_workers
key_name        = var.key_name
project         = var.project
}
