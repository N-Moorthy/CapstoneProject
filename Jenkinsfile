pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('DOCKER_HUB_CREDENTIALS')
    }
    triggers {
        // Poll the repository every 5 minutes (adjust as necessary)
        pollSCM('H/5 * * * *')
    }
    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    def branchName = env.BRANCH_NAME ?: 'Prod'
                    checkout([$class: 'GitSCM', branches: [[name: "*/${branchName}"]],
                              doGenerateSubmoduleConfigurations: false, extensions: [],
                              userRemoteConfigs: [[url: 'https://github.com/N-Moorthy/CapstoneProject.git',
                                                   credentialsId: '3c5cf833-313a-4c9a-bf52-3e2609df6860']]])
                }
            }
        }
        stage('Build') {
            steps {
                sh '''
                    chmod +x build.sh
                    ./build.sh
                '''
            }
        }
        stage('Deploy') {
            steps {
                sh '''
                    chmod +x deploy.sh
                    ./deploy.sh
                '''
            }
        }
    }
    post {
        always {
            echo 'Cleaning up...'
            sh 'docker logout'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}


