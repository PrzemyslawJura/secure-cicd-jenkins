# 🧱 Secure CI/CD Pipeline with Jenkins

## 🔍 Overview
This project demonstrates how to build a **secure CI/CD pipeline** using **Jenkins**, **Docker**, **Bandit**, and **Trivy**.

## ⚙️ Pipeline Stages
1. **Checkout** – Clone source code  
2. **Install Dependencies** – Set up Python environment  
3. **Unit Tests** – Run tests using PyTest  
4. **Static Code Analysis (Bandit)** – Detect security issues in code  
5. **Docker Build** – Create container image  
6. **Vulnerability Scan (Trivy)** – Scan container image for CVEs  
7. **Deploy** – Optional local container deployment  

## 🛡️ Security Highlights
- Non-root user in Docker image  
- Automated code and container scanning  
- Continuous testing  
- Post-build cleanup  

## 🧰 Tools Used
- **Jenkins** – CI/CD orchestration  
- **Docker** – Containerization  
- **Bandit** – Static code analysis  
- **Trivy** – Vulnerability scanning  
- **PyTest** – Unit testing  

## 📂 Project Structure
