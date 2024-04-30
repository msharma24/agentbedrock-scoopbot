#----------------------------------------------------------------
# Bedrock Agent
#----------------------------------------------------------------
resource "aws_bedrockagent_agent" "scoopbot_delight_agent" {
  agent_name                  = "scoopbot-delight-agent"
  instruction                 = "You are an agent that helps customer purchase ice cream. Retreive the customer traits by customer name and then recommend theem ice cream flavor that best matches the customer trait. After customer indictes they would like to order the ice cream, please order for icecream"
  agent_resource_role_arn     = module.bedrock_agent_exec_iam_assumable_role.iam_role_arn
  idle_session_ttl_in_seconds = 600
  foundation_model            = "anthropic.claude-v2"
}

#--------------------------------------------------------------
# Bedrock agent action grou
#--------------------------------------------------------------
resource "aws_bedrockagent_agent_action_group" "scopbot_delight_action_group" {
  action_group_name          = "scopbot-delight-action-group"
  agent_id                   = aws_bedrockagent_agent.scoopbot_delight_agent.id
  agent_version              = "DRAFT"
  skip_resource_in_use_check = true

  action_group_executor {
    lambda = module.scoopbot_lambda_function.lambda_function_arn
  }

  api_schema {

    payload = file("${path.module}/open-api-schema/openapispec.yaml")

  }
}
