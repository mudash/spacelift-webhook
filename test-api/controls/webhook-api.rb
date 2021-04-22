# copyright: 2021, Mudassar Shafique

title "Test Spacelift Webhook Infra"

# terraform output
content = inspec.profile.file("terraform.json")
params = JSON.parse(content)

HTTP_URL = params['deployment-url']['value']

# Check the API is deployed successfully
control "api-live-check" do                                     
  impact 1.0                                                                
  title "Check to see deployed API is live."  
  describe http(HTTP_URL, enable_remote_worker: true,
                method: 'POST', 
                headers: {'Content-Type' => 'application/json'}, 
                data: '{"message":"deployment test"}') do
        its('status') { should cmp 200 }
        its('body') { should cmp '{}' }
  end                                
end
