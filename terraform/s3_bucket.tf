#----------------------------------------
# Creating Amazon S3 bucket to hold source data for agent
#--------------------------------------

#------------------------------------------                     
module "agent_data_uploads_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.1"

  bucket = "${var.environment}-agent-data-upload-${local.random_pet}"
  #  acl    = "private"                                         



}

output "agent_data_uploads_s3_bucket" {
  description = "The name of the S3 bucket for agent data uploads"
  value       = module.agent_data_uploads_s3_bucket.s3_bucket_id
}
