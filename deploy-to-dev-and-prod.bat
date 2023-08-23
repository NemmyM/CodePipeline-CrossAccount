set REGION=us-east-1
set STACK_NAME=projectx-crossaccount-roles

:: Deploy the template
aws cloudformation deploy --template-file template/02deployment-roles.yaml --stack-name %STACK_NAME% --parameter-overrides file://parameter-overrides.json --capabilities CAPABILITY_NAMED_IAM --region %REGION%
