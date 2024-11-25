# terraform-aws-lambda

This repository demonstrates how to deploy an AWS Lambda function using **Terraform**. The steps below will guide you through setting up Terraform, configuring AWS credentials, and deploying a Lambda function.

---

## Features

- Automates the deployment of an AWS Lambda function.
- Includes IAM role creation for Lambda execution.
- Allows configuration of environment variables for the Lambda function.

---

## Prerequisites

1. **Terraform**: Install Terraform from the [official website](https://developer.hashicorp.com/terraform/downloads).
2. **AWS CLI**: Install and configure the AWS CLI from [here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
3. **AWS Account**: Ensure you have access to an AWS account with permissions to create Lambda functions and IAM roles.
4. **Node.js** (if using Node.js for the Lambda runtime).

---

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/umerxk/terraform-aws-lambda.git
cd terraform-aws-lambda.git

### 2. Set Up AWS Credentials
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"


### 3. Initialize Terraform
terraform init


### 4. Prepare Your Lambda Function
Write your Lambda code in index.js.
Compress the file into a ZIP archive:
zip lambda.zip index.js


### 5. Prepare Your Lambda Function
Preview Changes: terraform plan
Apply Changes: terraform apply
