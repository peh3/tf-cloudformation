# tf-cloudformation

This Terraform project bootstraps the foundational AWS infrastructure required to deploy CloudFormation stacks from GitHub Actions without using static AWS IAM credentials.

It configures:
- Reference to the AWS IAM OpenID Connect (OIDC) Identity Provider (`token.actions.githubusercontent.com`).
- An IAM deployment role configured with a federated trust policy that supports both **immutable ID claims** (`owner@id/repo@id`) and legacy claims.
- Deployment permissions for AWS CloudFormation and target services (e.g., S3).

---

## Architecture Overview

```text
GitHub Actions Workflow
      │ (OIDC Token with immutable claims)
      ▼
AWS STS (AssumeRoleWithWebIdentity)
      │ (Validates token and trust policy)
      ▼
Temporary AWS Credentials
      │
      ▼
AWS CloudFormation & Resources
