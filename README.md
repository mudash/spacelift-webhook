
# Spacelift webhook persistence

Technical assignment for Spacelift. It includes a Terraform module that creates an API using AWS API Gateway that persists the Spacelift webhook data in a Dynamo DB Table.

## How to use it
 
a) Clone the repository:

        git clone https://github.com/mudash/spacelift.git

b) Change directory into the project folder and use regular terraform commands to init, plan and apply
         
        terraform init
        terraform plan
        terraform apply
 
The terraform execution will output the URL of the deployed API. 

## Sample Output
  

```
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.space_webhook.aws_api_gateway_rest_api.WebhookAPI: Creating...
module.space_webhook.aws_iam_role.api-gateway-role: Creating...
module.space_webhook.aws_dynamodb_table.WebhookTable: Creating...
module.space_webhook.aws_api_gateway_rest_api.WebhookAPI: Creation complete after 5s [id=46tl8unx2f]
module.space_webhook.aws_api_gateway_resource.Spacelift: Creating...
module.space_webhook.aws_iam_role.api-gateway-role: Creation complete after 7s [id=api-gateway-dynamo-role-tf]
module.space_webhook.aws_api_gateway_resource.Spacelift: Creation complete after 4s [id=kub72v]
module.space_webhook.aws_api_gateway_method.API_Method: Creating...
module.space_webhook.aws_dynamodb_table.WebhookTable: Still creating... [10s elapsed]
module.space_webhook.aws_api_gateway_method.API_Method: Creation complete after 2s [id=agm-46tl8unx2f-kub72v-POST]
module.space_webhook.aws_api_gateway_method_response.post-response-200: Creating...
module.space_webhook.aws_api_gateway_integration.API_Integration: Creating...
module.space_webhook.aws_api_gateway_method_response.post-response-200: Creation complete after 2s [id=agmr-46tl8unx2f-kub72v-POST-200]
module.space_webhook.aws_dynamodb_table.WebhookTable: Creation complete after 15s [id=spacedata]
module.space_webhook.aws_iam_role_policy.api-gateway-policy: Creating...
module.space_webhook.aws_api_gateway_integration.API_Integration: Creation complete after 5s [id=agi-46tl8unx2f-kub72v-POST]
module.space_webhook.aws_api_gateway_integration_response.post-response: Creating...
module.space_webhook.aws_api_gateway_deployment.WebhookDeployment: Creating...
module.space_webhook.aws_iam_role_policy.api-gateway-policy: Creation complete after 4s [id=api-gateway-dynamo-role-tf:api-gateway-dynamo-policy-tf]
module.space_webhook.aws_api_gateway_deployment.WebhookDeployment: Creation complete after 4s [id=ikj662]
module.space_webhook.aws_api_gateway_integration_response.post-response: Creation complete after 4s [id=agir-46tl8unx2f-kub72v-POST-200]
module.space_webhook.aws_api_gateway_stage.WebhookDeployStage: Creating...
module.space_webhook.aws_api_gateway_stage.WebhookDeployStage: Creation complete after 4s [id=ags-46tl8unx2f-V1]

Apply complete! Resources: 11 added, 0 changed, 0 destroyed.

Outputs:

deployment-url = "The API has been deployed at: https://46tl8unx2f.execute-api.us-east-1.amazonaws.com/V1/spacelift"

```
