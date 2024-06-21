pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: '${BRANCH_NAME}', url: 'https://github.com/N-Moorthy/CapstoneProject.git'
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
}
