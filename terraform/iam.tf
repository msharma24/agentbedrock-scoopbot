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
  create_instance_profile = trueiam

  role_name = "AmazonBedrockExecutionRoleForAgent_scoopbot"

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSLambda_FullAccess",
    aws_iam_policy.bedrock_foundation_model_policy.arn,
    aws_iam_policy.bedrock_knowledge_base_retrieve_policy.arn

  ]
}

output "bedrock_exec_role_role_name" {
  description = "The name of the Bedrock exec IAM role"
  value       = module.bedrock_agent_exec_iam_assumable_role.iam_role_arn
}


resource "aws_iam_policy" "bedrock_foundation_model_policy" {

  name        = "BedrockFoundationModelPolicy"
  path        = "/"
  description = "Policy to allow invoking specific Bedrock foundation models"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AmazonBedrockAgentBedrockFoundationModelPolicy"
        Effect = "Allow"
        Action = "bedrock:InvokeModel"
        Resource = [
          "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-v2",
          "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-instant-v1",
          "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-v3",
          "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-v2:1"
        ]
      },
    ]
  })
}


resource "aws_iam_policy" "bedrock_knowledge_base_retrieve_policy" {

  name        = "BedrockKnowledgeBaseRetrievePolicy"
  path        = "/"
  description = "Policy to allow retrieving specific Bedrock knowledge bases"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AmazonBedrockAgentRetrieveKnowledgeBasePolicyProd"
        Effect = "Allow"
        Action = [
          "bedrock:Retrieve"
        ]
        Resource = [
          "arn:aws:bedrock:${local.region}:${local.account_id}:knowledge-base/*"
        ]
      },
    ]
  })
}
