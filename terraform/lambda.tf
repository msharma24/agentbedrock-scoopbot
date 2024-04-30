module "scoopbot_lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "scoopbot-lambda1"
  description   = "scoopbot bedrock agent action group lambda function 1"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  source_path = "./lambda/scoopbot-lambda"

  attach_policy_json = true

  policy_json = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ssm:GetParameter",
              "kms:Decrypt",
              "s3:*",
              "sqs:*"
            ],
            "Resource": ["*"]
        }
    ]
}
EOF




  tags = {
    Name = "scoopbot-lambda1"
  }
}


#--------------------------------------------------------------                      
# This is the lambda permission to allow bedrock agent to invoke the lambda function 
# --------------------------------------------------------------                     
resource "aws_lambda_permission" "bedrock_invoke_permission" {
  statement_id  = "AllowExecutionFromBedrock"
  action        = "lambda:InvokeFunction"
  function_name = module.scoopbot_lambda_function.lambda_function_name
  principal     = "bedrock.amazonaws.com"
  source_arn    = aws_bedrockagent_agent.scoopbot_delight_agent.agent_arn

}
