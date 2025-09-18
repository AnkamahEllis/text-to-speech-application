# Text-to-Speech on AWS (Terraform Project)

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

---

## Architecture Diagram Walkthrough
- Host the frontend (html + css + js) on S3 static hosting to achieve cost efficiency
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
- A video walkthrough with the testing of the project
