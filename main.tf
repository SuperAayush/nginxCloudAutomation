module "vpc" {
  source = "./module/vpc"
}

module "ssh" {
  source = "./module/key_pair"
  key_name = "ngx_automation_key"
}