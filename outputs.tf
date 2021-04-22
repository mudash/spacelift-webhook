##############################################################
# Output variables - root module
##############################################################
##############################################################
# Output the Dynamo DB Table Name
##############################################################
output "deployment-url" {
  value = join("",["${module.space_webhook.api-invoke-url}", 
    "${module.space_webhook.api-stage-name}", "/", "${module.space_webhook.api-resource}"])
}

##############################################################
# Output the Dynamo DB Table Name
##############################################################
output "data-table" {
  value = "${module.space_webhook.dynamo-table}"
}

##############################################################
# Output the Role arn
##############################################################
output "api-role" {
  value = "${module.space_webhook.api-role}"
}