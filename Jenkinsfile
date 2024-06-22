pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('DOCKER_HUB_CREDENTIALS') // Your Docker Hub credentials ID
    }
    triggers {
        pollSCM('H/5 * * * *') // Poll the repository every 5 minutes
    }
    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    def branchName = env.BRANCH_NAME ?: 'Dev' // Default to Prod if BRANCH_NAME is not set
                    echo "Checking out branch: ${branchName}"
                    checkout([$class: 'GitSCM', branches: [[name: branchName]],
                              userRemoteConfigs: [[url: 'https://github.com/N-Moorthy/CapstoneProject.git',
                                                   credentialsId: '3c5cf833-313a-4c9a-bf52-3e2609df6860']]])
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    sh 'chmod +x build.sh'
                    sh './build.sh'
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh 'chmod +x deploy.sh'
                    sh './deploy.sh'
                }
            }
        }
    }
    post {
        always {
            script {
                echo 'Cleaning up...'
                sh 'docker logout'
            }
        }
        failure {
            script {
                echo 'Deployment failed.'
            }
        }
    }
}
