# Cloud Resume Challenge - Backend

This repository contains the backend code for my submission to the Cloud Resume Challenge. It provides the necessary APIs and serverless functions to support the frontend of the application.

## Overview

The backend is built using serverless architecture on AWS, leveraging various services such as AWS Lambda, API Gateway, and DynamoDB. It serves as the backend for the frontend application, handling requests from the contact form and visitor counter.

Everything is then deployed using IaC with Terraform.

## Technologies Used

- API Gateway: Gets called from the JavaScript file in the frontend with two different methods, GET and PUT. Each method calls a different Lambda function.
- AWS Lambda: Two different functions triggered by API Gateway, one writes to DynamoDB and the other ones reads the data. Both functions are written in Python.
- DynamoDB: Hosts a simple visitor counter, and responds to Lambda functions
- Terraform: Used to deploy the backend with IaC.
- GitHub Actions: For CI/CD, performs a simple mock test on the GET Lambda function.

## APIs and Endpoints

API Gateway has been configured using two different methods, GET and PUT. Each method triggers a distinct Lambda function, one that increases the visits counter on DynamoDB, and another one that fetches the counter and returns it. The visits counter is then displayed on the frontend.

## Resources

- Frontend repo: https://github.com/galzmarc/cloud-resume-challenge-frontend
- Cloud Resume Challenge official website: https://cloudresumechallenge.dev/docs/the-challenge/aws/