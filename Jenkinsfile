pipeline {
    agent any
    tools {
        terraform 'terraform-instlltn'
    }

    stages {
        stage('Git Checkout') {
            steps {

                git credentialsId: 'tftest-2', url: 'https://github.com/m-voels/tftest', branch: 'dev'

            }
        }
        stage('terraform init') {
            steps {
                sh 'terraform init'
                sh 'terraform validate'
            }
        }
        stage('terraform apply') {
            when {
                branch "dev"
            }
            steps {

                sh 'aws s3 cp s3://mvil-glue/terraform.tfstate ./terraform.tfstate'
                sh 'terraform apply --auto-approve'
                sh 'aws s3 cp ./terraform.tfstate s3://mvil-glue/terraform.tfstate'

            }
        }
    }
}