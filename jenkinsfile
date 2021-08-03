pipeline {
    agent any
    tools {
        terraform 'terraform-instlltn'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git credentialsId: 'tftest-2', url: 'https://github.com/m-voels/tftest'
            }
        }
        stage('terraform init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('terraform apply') {
            steps {
                sh 'terraform apply --auto-approve'
                sh 'cat terraform.tfstate'
            }
        }
    }
}