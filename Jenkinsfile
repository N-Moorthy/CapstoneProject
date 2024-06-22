pipeline {
    agent any

    environment {
	BRANCH_NAME = 'Dev' 'Prod'
        DOCKER_HUB_CREDENTIALS = credentials('DOCKER_HUB_CREDENTIALS')
    }

    stages {
        stage('Checkout SCM') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: "*/${BRANCH_NAME}"]],
                          doGenerateSubmoduleConfigurations: false, extensions: [],
                          userRemoteConfigs: [[url: 'https://github.com/N-Moorthy/CapstoneProject.git',
                                               credentialsId: '3c5cf833-313a-4c9a-bf52-3e2609df6860']]])
            }
        }

        stage('Build') {
            steps {
                sh './build.sh'
            }
        }

        

        stage('Deploy') {
            steps {
                sh './deploy.sh'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh 'docker logout'
        }
        success {
            echo 'Deployment succeeded!'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}

