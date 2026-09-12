# 1. Fetch AWS Account ID dynamically
data "aws_caller_identity" "current" {}

# 2. Reference the ALREADY CREATED OIDC Provider
# Option A: Look it up via data source using its URL
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

# 3. IAM Assume Role Trust Policy (Scoped to your repo)
data "aws_iam_policy_document" "github_oidc_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      # Points directly to your existing provider's ARN
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Restrict execution strictly to your repository
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      #values   = ["repo:${var.github_repo}:*"]
      values   = var.github_repos
    }
  }
}

# 4. Create the IAM Deployment Role
resource "aws_iam_role" "github_actions_deployer" {
  name               = "tk-github-actions-cloudformation-deployer"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
  description        = "IAM role assumed by GitHub Actions to deploy CloudFormation stacks"
}

# 5. Attach Policies
resource "aws_iam_role_policy_attachment" "cloudformation_access" {
  role       = aws_iam_role.github_actions_deployer.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role       = aws_iam_role.github_actions_deployer.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}