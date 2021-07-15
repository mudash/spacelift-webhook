
# Spacelift webhook persistence
# As a Sample Spacelift Module

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

module.space_webhook.aws_iam_role.api-gateway-role: Creating...
module.space_webhook.aws_api_gateway_rest_api.WebhookAPI: Creating...
module.space_webhook.aws_dynamodb_table.WebhookTable: Creating...
module.space_webhook.aws_api_gateway_rest_api.WebhookAPI: Creation complete after 6s [id=690luqrlf2]
module.space_webhook.aws_api_gateway_resource.Spacelift: Creating...
module.space_webhook.aws_iam_role.api-gateway-role: Creation complete after 9s [id=api-gateway-dynamo-role-tf]
module.space_webhook.aws_dynamodb_table.WebhookTable: Still creating... [10s elapsed]
module.space_webhook.aws_api_gateway_resource.Spacelift: Creation complete after 4s [id=8y4cmx]
module.space_webhook.aws_api_gateway_method.API_Method: Creating...
module.space_webhook.aws_api_gateway_method.API_Method: Creation complete after 2s [id=agm-690luqrlf2-8y4cmx-POST]
module.space_webhook.aws_api_gateway_method_response.post-response-200: Creating...
module.space_webhook.aws_api_gateway_integration.API_Integration: Creating...
module.space_webhook.aws_api_gateway_method_response.post-response-200: Creation complete after 2s [id=agmr-690luqrlf2-8y4cmx-POST-200]
module.space_webhook.aws_dynamodb_table.WebhookTable: Creation complete after 16s [id=spacedata]
module.space_webhook.aws_iam_role_policy.api-gateway-policy: Creating...
module.space_webhook.aws_api_gateway_integration.API_Integration: Creation complete after 4s [id=agi-690luqrlf2-8y4cmx-POST]
module.space_webhook.aws_api_gateway_integration_response.post-response: Creating...
module.space_webhook.aws_api_gateway_deployment.WebhookDeployment: Creating...
module.space_webhook.aws_api_gateway_integration_response.post-response: Creation complete after 4s [id=agir-690luqrlf2-8y4cmx-POST-200]
module.space_webhook.aws_iam_role_policy.api-gateway-policy: Creation complete after 4s [id=api-gateway-dynamo-role-tf:api-gateway-dynamo-policy-tf]
module.space_webhook.aws_api_gateway_deployment.WebhookDeployment: Creation complete after 4s [id=qrwwqy]
module.space_webhook.aws_api_gateway_stage.WebhookDeployStage: Creating...
module.space_webhook.aws_api_gateway_stage.WebhookDeployStage: Creation complete after 4s [id=ags-690luqrlf2-V1]

Apply complete! Resources: 11 added, 0 changed, 0 destroyed.

Outputs:

api-role = "api-gateway-dynamo-role-tf"
data-table = "spacedata"
deployment-url = "https://690luqrlf2.execute-api.us-east-1.amazonaws.com/V1/spacelift"

```
## Testing with InSpec

Test the deployed AWS Infra components:

```
terraform output --json > ./test-webhook/files/terraform.json
inspec exec test-webhook -t aws:// 

Profile: AWS InSpec Profile (test-webhook)
Version: 0.1.0
Target:  aws://

  ✔  dynamo-table-exists-check: Check to see if dynamo db table exists.
     ✔  AWS Dynamodb table spacedata is expected to exist
  ✔  iam-role-exists-check: Check to see if IAM role for API Gateway exists.
     ✔  AWS IAM Role api-gateway-dynamo-role-tf is expected to exist


Profile: Amazon Web Services  Resource Pack (inspec-aws)
Version: 1.35.0
Target:  aws://

     No tests executed.

Profile Summary: 2 successful controls, 0 control failures, 0 controls skipped

```
Test the deployed API

```
terraform output --json > ./test-webhook/files/terraform.json
inspec exec test-api 

Profile: AWS InSpec Profile (test-api)
Version: 0.1.0
Target:  local://

  ✔  api-live-check: Check to see deployed API is live.
     ✔  HTTP POST on https://690luqrlf2.execute-api.us-east-1.amazonaws.com/V1/spacelift status is expected to cmp == 200
     ✔  HTTP POST on https://690luqrlf2.execute-api.us-east-1.amazonaws.com/V1/spacelift body is expected to cmp == "{}"


Profile: Amazon Web Services  Resource Pack (inspec-aws)
Version: 1.35.0
Target:  local://

     No tests executed.

Profile Summary: 1 successful control, 0 control failures, 0 controls skipped
Test Summary: 2 successful, 0 failures, 0 skipped
```

