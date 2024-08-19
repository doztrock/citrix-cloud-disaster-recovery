
# Citrix Cloud Disaster Recovery

This repository contains resources to set up a disaster recovery (DR) solution for Citrix Cloud. The Terraform configurations, scripts, and templates help automate the setup of DR environments using AWS infrastructure.

## Directory Structure

```
citrix-cloud-disaster-recovery-master/
│
├── .gitignore                    # Files ignored by Git
├── .terraform.lock.hcl           # Terraform dependency lock file
├── README.md                     # Project documentation
├── ec2.tf                        # EC2 instance definitions
├── iam.tf                        # AWS IAM roles and policies
├── providers.tf                  # Terraform providers configuration
├── scripts.tf                    # Script execution definitions
├── variables.tf                  # Input variables for Terraform
├── vpc.tf                        # AWS VPC setup for DR environment
│
├── mRemoteNG/                    # mRemoteNG configuration templates
│   ├── .gitignore
│   └── confCons.xml.tpl           # mRemoteNG connection template
│
└── script/                       # PowerShell scripts for DR deployment
    ├── .gitignore
    ├── userdata.ps1              # User data script for instance initialization
    └── template/                 # Templated deployment scripts
        ├── deploy-dr-dc.tpl      # Template for deploying DR domain controller
        ├── deploy-main-dc.tpl    # Template for deploying main domain controller
        ├── join.tpl              # Script template for joining instances to domain
        ├── set-dns-dc.tpl        # Script for setting DNS on domain controllers
        └── set-replication-time.tpl # Template for setting replication time
```

## Overview

This repository provides a Terraform-based approach to deploy disaster recovery infrastructure for Citrix Cloud environments, utilizing AWS resources. It includes configuration files for EC2 instances, VPCs, IAM roles, and templates for configuring domain controllers in a disaster recovery scenario.

### Key Components

- **Terraform Configuration**: Manages AWS infrastructure.
- **PowerShell Scripts**: Automates tasks like joining domain controllers, configuring DNS, and setting replication schedules.
- **mRemoteNG Templates**: Provides predefined templates for managing remote connections using mRemoteNG.

## Setup Instructions

1. Install Terraform and configure AWS CLI with proper credentials.
2. Clone this repository and modify the `variables.tf` file to suit your environment.
3. Run `terraform init` to initialize the Terraform configuration.
4. Execute `terraform apply` to deploy the DR environment.
