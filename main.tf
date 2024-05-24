module "vpc" {
  source = "./tf_module/vpc"
}

module "ssh" {
  source = "./tf_module/key_pair"
  key_name = "ngx_automation_key"
}

module "ec2" {
  source = "./tf_module/instance"
  key_name = module.ssh.key_name
  vpc_id = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_ids[0]
  public_subnet_id = module.vpc.public_subnet_ids[0]
  private_key_path = "/Users/SuperAayush/Desktop/projects/nginxCloudAutomation/tf_module/ssh/generated_key.pem"
  alb_security_group_id = module.vpc.alb_security_group_id
}

module "app_lb" {
  source               = "./tf_module/load_balancer"
  public_subnets      = module.vpc.public_subnet_ids
  alb_security_group_id = module.vpc.alb_security_group_id 
  vpc_id               = module.vpc.vpc_id
  instance_ids         = module.ec2.private_instance_ids
}

module "api_gateway" {
  source      = "./tf_module/api_gateway"
  alb_dns_name = module.app_lb.alb_dns_name
}