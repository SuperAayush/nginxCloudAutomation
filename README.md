
# Automate Nginx Web Server Deployment Using Terraform and Ansible

This project uses Terraform to deploy a scalable and secure AWS infrastructure, featuring a VPC with a large CIDR block, SSH keypair management, multi-zone EC2 deployment, Ansible integration, and a robust networking setup including a NAT Gateway, Internet Gateway, and Application Load Balancer (ALB). The architecture also includes an API Gateway module to expose services via the ALB.

## Prerequisites

- AWS Account
- Terraform installed
- Ansible installed
- AWS CLI configured

## Initial Setup

1. **Configure AWS CLI in the local System**:
   Ensure your AWS CLI is configured with at least `AdministratorAccess`. Run the following:
   ```bash
   aws configure
   ```

2. **Clone the Repository**

```bash
git clone https://github.com/SuperAayush/nginxCloudAutomation.git
cd nginxCloudAutomation
```   


3. **Configure required paths for the project**:
   In `main.tf`, update the actual path of your `key_pair.pem`. In `module/instance/main.tf`, configure the template file path and file name path. 

  

## Use Terraform Commands to Create Infrastructure

1. **Initialize**:
   ```bash
   terraform init
   ```

2. **Plan**:
   ```bash
   terraform plan
   ```

3. **Apply**:
   Apply the Terraform configuration to start building the infrastructure:
   ```bash
   terraform apply
   ```

4. Automation ensures that Ansible does not require manual intervention.


## Verifying from AWS

1. After completing all steps, go to your AWS Console. You should see that instances are running, and the load balancer is configured properly.
2. Locate the API Gateway named `nginx-api` where our Nginx is deployed.
3. Click on the stages and navigate to "final" stage to copy the Invoke URL and paste it into the browser.


## Tips
Don't forget to run `terraform destroy` after playing around.
