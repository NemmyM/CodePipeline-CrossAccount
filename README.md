# AWS CodePipeline Cross-Account Deployment Solution

This repository provides an automated solution for deploying AWS CodePipeline across multiple accounts (tooling/DevOps, development, and production). It leverages AWS CloudFormation templates and scripts to create a seamless deployment process. The solution expects three accounts: CI/CD dedicated account, development and production accounts. If email is provided in the parameters file, then a manual approval will run before deploying into the production account.

The stack supports GitHub and CodeCommit as a source. Specify GitType variable to "CodeCommit" or "GitHub" in parameter-overrides.json
If the GitType is "GitHub", ensure that "GitRepo" variable is in the format "repo-owner/repository_name". On the other hand, CodeCommit expects "GitRepo" to be just the "RepoName".
The build stage of the project expects buildspec.yml for build instructions, and the output artifact of it should be a cloudformation template named "template-export.yml".
Out of the box if repository is left unconfigured, the project will use a GitHub repository with sample SAM REST Lambda DynamoDB Node.js project.

## Prerequisites

- AWS CLI installed and configured with appropriate permissions.
- AWS accounts for tooling/DevOps, development, and production environments.
- Knowledge of AWS CloudFormation, CodePipeline, IAM, and related AWS services.

## Files and Description

1. **template/01tooling-pipeline.yaml**: CloudFormation template to define the CodePipeline in the tooling/DevOps account.
2. **template/02deployment-roles.yaml**: CloudFormation template to define roles and permissions for development and production accounts.
3. **deploy-to-dev-and-prod.bat**: Batch script for deployment to development and production accounts.
4. **deploy-to-pipeline-account.bat**: Batch script for deployment to the tooling/DevOps account.
5. **parameter-overrides.json**: JSON file containing parameters to override during deployment.

## Deployment Steps

1. **Tooling/DevOps Account Setup**:
   - Populate `parameter-overrides.json` with the required parameters:
     - Project: Project name. Stacks and IAM permissions in child accounts will be named with this parameter. This enables scoping down deployment role permissions.
     - DevAccount: Staging account. Codepipeline will deploy here first. If "Email" is set, manual approval will email with details of this test environment.
     - ProductionAccount: Final deployment will be running here.
   
   - Optionally, edit the STACK_NAME variable in the `deploy-to-pipeline-account.bat`. Having these unique allows for multiple instances of the setup.
   - Run `deploy-to-pipeline-account.bat` in the tooling/DevOps account.
     This will set the "FirstRun" parameter flag from "true" to "false," which will be used by this script later to finalize the setup once the dev and prod accounts are set up.

2. **Development Account Setup**:
   - Switch to development account credentials.
   - Optionally, edit the STACK_NAME variable in the `deploy-to-pipeline-account.bat`
   - Run `deploy-to-dev-and-prod.bat`.
     - This will deploy a Cloudformation stack with the necessary roles so that CodePipeline deployment account assumes and deploys resources there.

3. **Production Account Setup**:
   - Switch to production account credentials.
   - Run `deploy-to-dev-and-prod.bat` again.
     - As in the case of the previous step, this will deploy a Cloudformation stack with the necessary roles so that CodePipeline deployment account assumes and deploys resources there.

4. **Finalize Setup**:
   - Run `deploy-to-pipeline-account.bat` again with the tooling/DevOps account.
     - This will update the deployment(Codepipeline) account, updating KMS and Artifact bucket IAM resource policies so that Dev and Prod accounts can access them.
     - The script uses "FirstRun" parameter that was automatically set upon first run in parameter-overrides.json to finalize the setup.

## Known Issues:

- Connection arn:aws:codestar-connections:REGION:ACCOUNT_ID:connection/31e2e243-e5ce-4a0b-97cc-0043cc6e5e39 is not in an available state
  Go to the CodePipeline, Settings -> Connections and make sure your Connection is in the Available state.
- These are Windows batch files. Who uses that? It would help if we had shell scripts as deliverables.
  Converting this to shell script is super easy, as these are basically just a few AWS CLI commands.


## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Feel free to contribute to this project by submitting issues, pull requests, or providing feedback. Your contributions are welcome!

## Contact

For any questions or support, please contact [Your Contact Information].