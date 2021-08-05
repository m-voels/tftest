terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_glue_trigger" "scheduled_trigger" {
  name     = "scheduled_trigger"
  schedule = "cron(0 0 * * ? *)"
  type     = "SCHEDULED"

  actions {
    job_name = aws_glue_job.tf-gluejob-scheduled-1.name
  }

  actions {
    job_name = aws_glue_job.tf-gluejob-scheduled-2.name
  }
}

resource "aws_glue_job" "tf-gluejob-scheduled-1" {
  name     = "tf-gluejob-scheduled-1"
  role_arn = "arn:aws:iam::152944667076:role/glue_helper"

  command {
    script_location = "s3://mvil-glue/MySQLBYOD.py"
  }
}

resource "aws_glue_job" "tf-gluejob-scheduled-2" {
  name     = "tf-gluejob-scheduled-2"
  role_arn = "arn:aws:iam::152944667076:role/glue_helper"

  command {
    script_location = "s3://mvil-glue/MySQLBYOD.py"
  }
}

resource "aws_glue_trigger" "conditional_trigger" {
  name = "conditional_trigger"
  type = "CONDITIONAL"

  actions {
    job_name = aws_glue_job.tf-gluejob-conditional-1.name
  }
  actions {
    job_name = aws_glue_job.tf-gluejob-conditional-2.name
  }

  predicate {
    conditions {
      job_name = aws_glue_job.tf-gluejob-scheduled-1.name
      state    = "SUCCEEDED"
    }
    conditions {
      job_name = aws_glue_job.tf-gluejob-scheduled-2.name
      state    = "SUCCEEDED"
    }
  }

}

resource "aws_glue_job" "tf-gluejob-conditional-1" {
  name     = "tf-gluejob-conditional-1"
  role_arn = "arn:aws:iam::152944667076:role/glue_helper"

  command {
    script_location = "s3://mvil-glue/MySQLBYOD.py"
  }
}

resource "aws_glue_job" "tf-gluejob-conditional-2" {
  name     = "tf-gluejob-conditional-2"
  role_arn = "arn:aws:iam::152944667076:role/glue_helper"

  command {
    script_location = "s3://mvil-glue/MySQLBYOD.py"
  }
}

resource "aws_sns_topic" "glue-topic" {
  name = "glue-topic"
}



resource "aws_sns_topic_subscription" "sns-topic-email-subscription" {
  topic_arn = aws_sns_topic.glue-topic.arn
  protocol  = "email"
  endpoint  = "matthewvoels@gmail.com"
}