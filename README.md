Details about setting up your AWS, AWS local profile(s), and Terraform environment is beyond the scope of this repository.

**Prequisites**
1. Access to AWS
2. Locally configured AWS profiles (i.e., ~/.aws/)
3. Functional Terraform development environment
Examples of some common modules are in the subdirecories of the root of this repository.
Implementation of the modules is validated by the terraform in ./test_modules_plan

**Usage**

 A successful apply implies modules are stable and can be consumed by downstream dependencies.

    cd test_modules_plan

    terraform init

    terraform plan -out=tfplan

    terraform apply tfplan

**If you syccessfully applied the plan, avoid accumlating AWS costs!!**

    terraform destroy OR 
        terraform destroy -auto-approve
    Alternatively execute the provided script which applies and destroys any deployed resources automatically
        test_modules_plan
        sh ./test_modules_plan/terraform_appy_with_auto_destroy_if_fail.sh*

***Codepipeline phases**

1. Get clone code from github
3. ??Deploy lambda that will trigger when model in S3 is updated.
2. Upload model to S3 triggers lambda
3. Lambda will execute rest calls to GPT.
4. Codebuild executes tests in repo
5. ??Interop with Terratest??
