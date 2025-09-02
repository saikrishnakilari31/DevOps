# Part 1 — Terraform: VPC, ALB, ASG, RDS, Security Groups, Bastion
This repo contains Terraform code to provision the infrastructure required for the Pi Credit DevOps assignment (Part 1).

## What this creates
- VPC with public and private subnets across 2 AZs
- Internet Gateway and NAT Gateways
- Route tables
- Application Load Balancer (ALB) in public subnets
- Auto Scaling Group (EC2) running a simple container via user-data (private subnets)
- RDS PostgreSQL instance in private subnets (Multi-AZ)
- Security groups for ALB, EC2, Bastion, and RDS

## IMPORTANT
- **Do not** store sensitive values in repository. Use AWS Secrets Manager / SSM or CI secrets.
- The backend.tf references an S3 bucket and DynamoDB table for state locking — create them first or update backend.tf to use a different bucket/key.

## Quick start (local)
1. Copy or move this folder to your machine or use the bundled archive.
2. Create a terraform.tfvars file (example in terraform.tfvars.example)
3. Initialize and apply:
   ```
   terraform init
   terraform plan -out plan.tfplan
   terraform apply "plan.tfplan"
   ```

## Notes
- The ASG uses user-data to run a Docker container for demo purposes. Replace with ECS/Fargate for production-grade container orchestration.
- For production, set `skip_final_snapshot = false` in rds.tf and configure snapshot retention.
- Lock down `bastion_allowed_cidr` to your IP (no 0.0.0.0/0 for SSH).

## Next steps
After this infra is up, continue to Part 2 to containerize the app and move to ECS/EKS. See assignment PDF for full requirements.
