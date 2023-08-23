set REGION=us-east-1
set STACK_NAME=projectx-codepipeline-crossaccount

:: Deploy the template
aws cloudformation deploy --template-file template/01tooling-pipeline.yaml --stack-name %STACK_NAME% --parameter-overrides file://parameter-overrides.json --capabilities CAPABILITY_NAMED_IAM --region %REGION%

:: Do not proceed on an error, as it would pollute parameter-overrides.json file
IF %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%

:: Get details from the main stack for later
aws cloudformation describe-stacks --stack-name %STACK_NAME% --query "Stacks[0].Outputs[?OutputKey=='FirstRun' || OutputKey=='GitType' || OutputKey=='GitRepo' || OutputKey=='GitBranch' || OutputKey=='email' || OutputKey=='Project' || OutputKey=='Email' || OutputKey=='DevAccount' || OutputKey=='ProductionAccount' || OutputKey=='RepoBranch' || OutputKey=='CMK' || OutputKey=='ArtifactBucket' || OutputKey=='Project' || OutputKey=='CentralAccount'].{ParameterKey: OutputKey, ParameterValue: OutputValue}" > parameter-overrides.json
