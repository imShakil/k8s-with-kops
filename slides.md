# Slides: IDP with Terraform + kOps (7–10 slides)

---

## Slide 1 — Title
**Internal Developer Platform (IDP)**
Terraform (AWS infra) + kOps (Kubernetes)

**Speaker note:** Quick intro: goal is to show how Terraform provisions foundation resources and kOps manages the Kubernetes cluster with state stored in S3.

---

## Slide 2 — Goals
- Build an Internal Developer Platform
- Use Terraform to provision AWS infra
- Use kOps to create/manage K8s cluster
- Store kOps state in S3 (versioned + encrypted)

**Speaker note:** Emphasize separation of concerns.

---

## Slide 3 — Architecture
(ASCII diagram or simple block diagram)

Laptop/CI -> Terraform -> AWS (S3, IAM, VPC)
Laptop/CI -> kOps (uses S3 state) -> AWS (EC2, ASG, ELB)

**Speaker note:** Explain the data flow and responsibilities.

---

## Slide 4 — Why gossip DNS?
- No domain purchase or Route53 needed
- Fast to demo and suitable for internal/dev

**Speaker note:** For production use Route53 + HTTPS.

---

## Slide 5 — Demo steps
1. terraform apply (creates S3, IAM, VPC)
2. set env vars (AWS creds + KOPS_STATE_STORE)
3. kops create cluster --name my-idp.k8s.local --yes
4. kubectl get nodes; deploy sample app

**Speaker note:** Mention validation and rolling updates.

---

## Slide 6 — Security considerations
- Replace demo IAM policy with least-privilege
- Protect S3 (encryption + versioning)
- Use private subnets for nodes in production

**Speaker note:** Call out what you'd change for real infra.

---

## Slide 7 — Decommision Resources
- Delete Cluster
- Run terraform destroy 

**Speaker note:** Cleaning Infra.

---

## Slide 8 — Thank you / Q&A

**Speaker note:** Offer to walk through code, or run a short live demo if time permits.

---

## Presentation Link
**Link:** https://1drv.ms/p/c/65f66b7d9052e1a2/IQCDoKp2juzDR4HsFGRqqS7xAfpt9XbHkANydBlGtai-ckE?e=eOLQf8
