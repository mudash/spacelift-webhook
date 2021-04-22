# copyright: 2021, Mudassar Shafique

title "Test Spacelift Webhook Infra"

# terraform output
content = inspec.profile.file("terraform.json")
params = JSON.parse(content)

DATA_TABLE = params['data-table']['value']
IAM_ROLE = params['api-role']['value']

# Check for the existence of dynamo db table creation
control "dynamo-table-exists-check" do                                     
  impact 1.0                                                                
  title "Check to see if dynamo db table exists."  
  describe aws_dynamodb_table(table_name: DATA_TABLE) do
    it { should exist }
  end                                
end

# Check for the existence of IAM Role used by AWS API Gateway
control "iam-role-exists-check" do                                     
  impact 1.0                                                                
  title "Check to see if IAM role for API Gateway exists."  
  describe aws_iam_role(role_name: IAM_ROLE) do
    it { should exist }
  end                               
end

