variable "github_repo" {
  type    = string
   #default = "peh3/cloud-formation-template"
    default = "peh3@34233025/cloud-formation-template@1367026954"
}

variable "github_repos" {
  type        = list(string)
  description = "List of allowed GitHub repository patterns for OIDC authentication."
  default = [
    "repo:peh3@34233025/cloud-formation-template@1367026954:*",
    "repo:peh3/cloud-formation-template:*"
  ]
}