# AWS CLI and Terraform Setup Guide  

## Prerequisites
Ensure you have the following installed on your machine:
- AWS Command Line Interface (AWS CLI)
- Terraform
- An AWS account with IAM user credentials
- Internet access

## Step 1: Install AWS CLI
### **Linux/macOS**
```sh
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```
### **Windows**
1. Download [AWS CLI for Windows](https://awscli.amazonaws.com/AWSCLIV2.msi)
2. Run the installer and follow the setup prompts

### **Verify Installation**
```sh
aws --version
```
Example output:
```
aws-cli/2.13.10 Python/3.9.12 Darwin/x86_64
```

## Step 2: Configure AWS CLI for Dev Profile
```sh
aws configure --profile dev
```
Enter the following details:
```
AWS Access Key ID [None]: YOUR_ACCESS_KEY
AWS Secret Access Key [None]: YOUR_SECRET_KEY
Default region name [None]: us-east-1  # Change based on your closest AWS region
Default output format [None]: json
```

## Step 3: Verify AWS CLI Configuration
```sh
aws configure list --profile dev
```
Expected Output:
```
Name                    Value             Type    Location
----                    -----             ----    --------
access_key              YOUR_ACCESS_KEY   config-file
secret_key              ****************  config-file
region                  us-east-1         config-file
```

## Step 4: Install Terraform
### **Linux/macOS**
```sh
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt update && sudo apt install terraform
```

### **Windows**
1. Download Terraform from [Terraform Downloads](https://developer.hashicorp.com/terraform/downloads)
2. Install the package and add Terraform to your system PATH.

### **Verify Installation**
```sh
terraform -v
```
Example output:
```
Terraform v1.3.7
```

## Step 5: Terraform Setup
Terraform uses configuration files written in HCL (HashiCorp Configuration Language) to define and provision infrastructure resources such as:
- **VPC (Virtual Private Cloud)**: Defines the network environment.
- **Subnets**: Logical subdivisions within a VPC.
- **EC2 Instances**: Virtual machines that run applications.
- **Security Groups**: Controls inbound and outbound traffic.
- **S3 Buckets**: Object storage for data and files.

Below are the essential Terraform commands to set up infrastructure:

### **Initialize Terraform**
```sh
terraform init
```
This command initializes the Terraform working directory, downloads provider plugins, and sets up the backend configuration.

### **Validate Configuration Files**
```sh
terraform validate
```
This checks for syntax errors and verifies that the Terraform configuration files are properly structured.

### **Plan the Infrastructure**
```sh
terraform plan -out=tfplan
```
This generates an execution plan, displaying the resources that will be created, modified, or destroyed.

### **Apply the Changes**
```sh
terraform apply tfplan
```
This command provisions the infrastructure as defined in the Terraform files.

### **Destroy Resources (If Needed)**
```sh
terraform destroy
```
This command removes all resources managed by the current Terraform configuration.

## Step 6: Set AWS Profile as Default (Optional)
To avoid using `--profile dev` in every command, set it as the default profile.

### **For Temporary Use**
```sh
export AWS_PROFILE=dev
```

