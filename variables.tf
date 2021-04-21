variable "aws_region" {
    default = "us-east-1"
}

variable "dynamo_table_name" {
    default = "spacedata"
}

variable "ddb_default_rcu" {
    default = "5"
}

variable "ddb_default_wcu" {
    default = "5"
}

variable "aws_gateway_stage" {
    default = "V1"
}