#--------------------------------------------------------------------------------
# Amazon Bedrock Execution IAM Role For Agents
#--------------------------------------------------------------------------------

#Important Note: Amazon Bedrock Execution IAM Role name For Agents must begin with  "AmazonBedrockExecutionRoleForAgents*"

module "bedrock_agent_exec_iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "5.39.0"

  trusted_role_services = [
    "bedrock.amazonaws.com"
  ]

  role_requires_mfa       = false
  create_role             = true
  create_instance_profile = true

  role_name = "AmazonBedrockExecutionRoleForAgent_scoopbot_${local.random_pet}"

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSLambda_FullAccess"

  ]
}

output "bedrock_exec_role_role_name" {
  description = "The name of the Bedrock exec IAM role"
  value       = module.bedrock_agent_exec_iam_assumable_role.iam_role_arn
}