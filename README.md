# Text-to-Speech on AWS (Terraform Project)

![homepage](ProjectFiles/homepage.png)

This project provisions a **Text-to-Speech web app** on AWS using Terraform.  
It deploys:
- An **S3 bucket** (for static frontend + audio files storage)
- An **AWS Lambda** function (Polly text-to-speech)
- An **API Gateway** (for invoking Lambda from frontend)
- Required **IAM roles/policies**

---

## Prerequisites

- [Terraform ≥ 1.5](https://developer.hashicorp.com/terraform/downloads)
- [AWS Account](https://aws.amazon.com/console/)
- [VS Code](https://code.visualstudio.com/download)
- AWS CLI configured with admin permissions

---

## Architecture Diagram Walkthrough
![architecture](Architecture-diagram.png)
- Host the frontend (html + css + js) on S3 with enabled static hosting
- A user makes a call to convert text to speech and the call is sent to API Gateway. 
- The API Gateway triggers a lambda function. The function sends the text (user input) to AWS Polly for synthesis and stores the audio file in a directory in the same S3 bucket
- The audio is sent back to the frontend for the user to listen to it
- S3 lifecycle is add to delete audio after 1 day to optimise cost

---
## Directories
#### Terraform
Contains two sub-directories:
- lambda - the lambda handler python code and lambda zip files can be found here
- modules - the api, lambda, and s3 terraform provisioning codes are found here

The main.tf file contains the terraform version, provider (AWS), default region, and references to the api, lambda, and s3 modules

#### Project Files
- A frontend sub-directory which contains the index.html, styles.css and app.js files for the static hosting
- Testing video walkthrough

---
## Project Walkthrough
1. cd into the Terraform folder
```bash
cd Terraform/
```

2. Initialise
```bash
terraform init
```

3. Validate syntax
```bash
terraform validate
```

4. Plan
```bash
terraform plan -out=tfplan
```

5. Apply the desired states
```bash
terraform apply "tfplan"
```

6. Copy the api_endpoint link and paste it into the index.html file line 58. That is where you have the window.API_BASE

7. upload the all files in the frontend directory in the s3-bucket. Create a folder "audio" in the same bucket for storing the generated audio files

8. copy and paste the s3 website_endpoint from the terraform apply output into a web browser and enjoy testing it