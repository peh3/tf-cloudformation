output "role_arn" {
  description = "The ARN of the IAM role for GitHub Actions (save as AWS_ROLE_ARN in GitHub Secrets)"
  value       = aws_iam_role.github_actions_deployer.arn
}