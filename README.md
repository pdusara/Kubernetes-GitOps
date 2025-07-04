# Kubernetes-GitOps

Deploy a Kubernetes cluster on AWS (EKS Free Tier), manage applications declaratively with GitOps (FluxCD or ArgoCD), and automate deployments using GitHub Actions.

---

## 🌟 Project Overview

This project provisions a **production-ready AWS EKS cluster** using **Terraform**, following Infrastructure as Code (IaC) and GitOps best practices.  
It is designed as a foundation for integrating GitOps tools like **ArgoCD** or **FluxCD**, enabling continuous, automated, and declarative application delivery.

---
```mermaid
graph TD
    subgraph Terraform
        A1[Provision AWS EKS Cluster]
        A2[Set Up IAM Roles & Policies]
        A3[Define Networking & Subnets]
        A4[Create Spot Worker Nodes]
    end

    subgraph AWS EKS Cluster
        B1[Kubernetes Control Plane]
        B2[Worker Nodes - Spot Instances]
        B3[Networking - VPC, Subnets, NAT]
    end

    subgraph GitOps Integration
        C1[ArgoCD/FluxCD Installed]
        C2[Application Repositories Connected]
        C3[Automated Deployments via Git]
    end

    subgraph CI/CD Pipeline
        D1[GitHub Actions]
        D2[Build & Test Application]
        D3[Deploy to EKS via GitOps]
    end

    A1 --> B1
    A4 --> B2
    A3 --> B3
    B1 --> C1
    B2 --> C2
    C2 --> C3
    D1 --> D2
    D2 --> D3
    D3 --> C3
```
---

## 🚀 Key Features

- **Modular Terraform**: Clean separation of IAM, networking, and EKS resources for reusability and clarity.
- **AWS EKS Cluster**: Secure, scalable Kubernetes cluster provisioned on AWS.
- **Spot Worker Nodes**: Cost-effective, auto-scaling node group using EC2 Spot Instances.
- **GitOps Ready**: Structure and outputs are designed for seamless integration with ArgoCD or FluxCD.
- **CI/CD Automation**: Ready for GitHub Actions or other CI/CD tools.

---

## 📁 Project Structure

```
Kubernetes-GitOps/
├── Terraform/
│   ├── main.tf           # Main resources (EKS, Node Group, Module calls)
│   ├── variables.tf      # All input variables
│   ├── locals.tf         # Local values (tags, names)
│   ├── outputs.tf        # Outputs for integration/automation
│   └── modules/
│       └── iam/          # IAM roles and policies as a reusable module
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
├── .gitignore
└── README.md
```

---

## 🔗 GitOps Integration

This infrastructure is built to be integrated with **ArgoCD** (or FluxCD) for GitOps workflows.  
Once the EKS cluster is provisioned, you can:

- Install ArgoCD or FluxCD on the cluster.
- Connect your application repositories.
- Manage deployments declaratively via Git.

**For a step-by-step guide to integrating ArgoCD with your EKS cluster, see:**  
[How to Integrate ArgoCD with EKS - Google Doc](https://docs.google.com/document/d/1sPCVpfW4xWJmXVsx_Ten_Fh_Bs_pasBcN2K5FZU9J4w/edit?usp=sharing)

---

## 🚦 Quick Start

1. **Clone the repo**
   ```sh
   git clone https://github.com/yourusername/Kubernetes-GitOps.git
   cd Kubernetes-GitOps/Terraform
   ```

2. **Initialize Terraform**
   ```sh
   terraform init
   ```

3. **Review and customize variables** in `variables.tf` and `locals.tf`.

4. **Plan and apply**
   ```sh
   terraform plan
   terraform apply
   ```

5. **Integrate with ArgoCD**
   - Install ArgoCD on your EKS cluster.
   - Point ArgoCD to your application Git repositories for automated, declarative deployments.
   - [Follow this integration guide.](https://docs.google.com/document/d/1sPCVpfW4xWJmXVsx_Ten_Fh_Bs_pasBcN2K5FZU9J4w/edit?usp=sharing)

---

## 👋 About Me

Hi, I’m Pritesh  
I’m passionate about DevOps, cloud automation, and GitOps.  
Connect with me on [LinkedIn](www.linkedin.com/in/pritesh-dusara-52709953) if you’re looking for a DevOps Engineer who delivers production-ready, automated cloud solutions!

---

> **If you’re hiring for Cloud roles, let’s talk!**
