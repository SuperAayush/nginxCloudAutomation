module "vpc" {
  source = "./tf_module/vpc"
}

module "ssh" {
  source = "./tf_module/key_pair"
  key_name = "ngx_automation_key"
}

module "ec2" {
  source = "./tf_module/ec2"
  key_name = module.ssh.key_name
  vpc_id = module.main_vpc.vpc_id
  private_subnet_id = module.main_vpc.private_subnet_ids[0]
  public_subnet_id = module.main_vpc.public_subnet_ids[0]
  private_key_path = "/Users/SuperAayush/Desktop/projects/nginxCloudAutomation/tf_module/ssh/generated_key.pem"
  alb_security_group_id = module.main_vpc.alb_security_group_id
}

module "app_lb" {
  source               = "./tf_module/alb"
  public_subnets      = module.main_vpc.public_subnet_ids
  alb_security_group_id = module.main_vpc.alb_security_group_id 
  vpc_id               = module.main_vpc.vpc_id
  instance_ids         = module.ec2.private_instance_ids
}