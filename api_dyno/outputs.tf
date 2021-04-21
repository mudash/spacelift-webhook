##############################################################
# Output the URL where API is deployed
##############################################################
output "api-invoke-url" {
  value = "${aws_api_gateway_deployment.WebhookDeployment.invoke_url}"
}

##############################################################
# Output the stage name
##############################################################
output "api-stage-name" {
  value = "${aws_api_gateway_stage.WebhookDeployStage.stage_name}"
}

##############################################################
# Output the API resource
##############################################################
output "api-resource" {
  value = "${aws_api_gateway_resource.Spacelift.path_part}"
}