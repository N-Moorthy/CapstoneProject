pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockercreds')
        GIT_REPO_URL = 'https://github.com/N-Moorthy/CapstoneProject.git'
        GIT_CREDENTIALS_ID = 'gitcreds'
    }        
        stage('Build') {
            steps {
                script {
                    sh 'chmod +x build.sh'
                    sh './build.sh'
                }
            }
        }
        
        stage('Push to Docker Hub') {
            when {
                expression {
                    // Push to Docker Hub only for Prod or Dev branches
                    env.BRANCH_NAME == 'Prod' || env.BRANCH_NAME == 'Dev'
                }
            }
        stage('Deploy') {
            when {
                expression {
                    // Deploy only if branch is 'Prod' or 'Dev'
                    env.BRANCH_NAME == 'Prod' || env.BRANCH_NAME == 'Dev'
                }
            }
            steps {
                script {
                    // Clean up previous deployments
                    sh 'docker-compose down'
                    
                    // Ensure deploy.sh is executable and run it with branch name argument
                    sh 'chmod +x deploy.sh'
                    sh "./deploy.sh ${env.BRANCH_NAME}"
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
