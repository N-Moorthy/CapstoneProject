pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('DOCKER_HUB_CREDENTIALS')
    }
    }
    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    // Checkout the branch that triggered the build
                    def branchName = env.BRANCH_NAME ?: 'Prod' // Default to Prod if BRANCH_NAME is not set
                    checkout([$class: 'GitSCM', branches: [[name: "*/${branchName}"]],
                              doGenerateSubmoduleConfigurations: false, extensions: [],
                              userRemoteConfigs: [[url: 'https://github.com/N-Moorthy/CapstoneProject.git',
                                                   credentialsId: '3c5cf833-313a-4c9a-bf52-3e2609df6860']]])
                }
            }
        }
        stage('Build') {
            steps {
                sh 'echo "Building the project..."'
                sh './build.sh'
            }
        }
        stage('Test') {
            steps {
                sh 'echo "Running tests..."'
                sh 'mvn test'
            }
        }
        stage('Deploy') {
            steps {
                sh './deploy.sh'          
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


