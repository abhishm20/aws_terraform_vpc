//resource "aws_codepipeline" "development-api-service-code-pipeline" {
//  name = "${var.app_name}-api-service-code-pipeline"
//  role_arn = aws_iam_role.development-code-pipeline-role.arn
//
//  artifact_store {
//    location = aws_s3_bucket.code-build-artifacts-bucket.bucket
//    type = "S3"
//
////    encryption_key {
////      id = aws_kms_alias.development-kms-alias.arn
////      type = "KMS"
////    }
//  }
//
//  stage {
//    name = "Source"
//
//    action {
//      name = "Source"
//      category = "Source"
//      owner = "AWS"
//      provider = "CodeCommit"
//      version = "1"
//      run_order = 1
//      output_artifacts = [
//        "SourceArtifact"]
//
//      configuration = {
//        RepositoryName = data.aws_codecommit_repository.api-service.repository_name
//        BranchName = var.api_service_deployment_branch_name
//      }
//    }
//  }
//
//  stage {
//    name = "Build"
//
//    action {
//      category = "Build"
//      configuration = {
//        //        "EnvironmentVariables" = jsonencode(
//        //          [
//        //            {
//        //              name  = "environment"
//        //              type  = "PLAINTEXT"
//        //              value = var.env
//        //            },
//        //          ]
//        //        )
//        "ProjectName" = aws_codebuild_project.api-service-code-build.name
//      }
//      input_artifacts = [
//        "SourceArtifact",
//      ]
//      name = "Build"
//      output_artifacts = [
//        "BuildArtifact",
//      ]
//      owner = "AWS"
//      provider = "CodeBuild"
//      run_order = 2
//      version = "1"
//    }
//  }
//
//  stage {
//    name = "Deploy"
//
//    action {
//      category = "Deploy"
//      configuration = {
//        "BucketName" = aws_s3_bucket.code-pipeline-artifacts-bucket.bucket
//        "Extract" = "false",
//        "ObjectKey" = "api-service/BuiltPackage.zip"
//        "CannedACL" = "bucket-owner-full-control"
//      }
//      input_artifacts = [
//        "BuildArtifact",
//      ]
//      name = "Deploy"
//      output_artifacts = []
//      owner = "AWS"
//      provider = "S3"
//      run_order = 3
//      version = "1"
//    }
//  }
//}
//
//resource "aws_codepipeline" "deployment-api-service-code-pipeline" {
//  name = "${var.app_name}-api-service-code-pipeline"
//  role_arn = aws_iam_role.deployment-code-pipeline-role.arn
//
//  artifact_store {
//    location = aws_s3_bucket.code-pipeline-artifacts-bucket.bucket
//    type = "S3"
//
//
////    encryption_key {
////      id = aws_kms_alias.development-kms-alias.arn
////      type = "KMS"
////    }
//  }
//
//  stage {
//    name = "Source"
//
//    action {
//      name = "Source"
//      category = "Source"
//      owner = "AWS"
//      provider = "S3"
//      version = "1"
//      run_order = 1
//      output_artifacts = [
//        "SourceArtifact"]
//
//      configuration = {
//        "S3Bucket" = aws_s3_bucket.code-pipeline-artifacts-bucket.bucket
//        "S3ObjectKey" = "api-service/BuiltPackage.zip"
//        "PollForSourceChanges" = "true"
//      }
//    }
//  }
//
//  stage {
//    name = "Deploy"
//
//    action {
//      category = "Deploy"
//      configuration = {
//        ApplicationName: aws_codedeploy_app.api-service.name
//        DeploymentGroupName: aws_codedeploy_deployment_group.api-service-group.deployment_group_name
//      }
//      input_artifacts = [
//        "SourceArtifact",
//      ]
//      name = "Deploy"
//      output_artifacts = []
//      owner = "AWS"
//      provider = "CodeDeploy"
//      run_order = 2
//      version = "1"
//    }
//  }
//}