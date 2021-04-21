
provider "aws" {
  region = var.aws_region
}

module "space_webhook" {
  source = "./api_dyno"
  aws_region = var.aws_region
  dynamo_table_name = var.dynamo_table_name
  ddb_default_rcu = var.ddb_default_rcu
  ddb_default_wcu = var.ddb_default_wcu
  aws_gateway_stage = var.aws_gateway_stage
}