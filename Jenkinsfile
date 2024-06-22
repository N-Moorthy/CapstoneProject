pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('DOCKER_HUB_CREDENTIALS') // Your Docker Hub credentials ID
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
	stage('Push to Docker Hub') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'Prod') {
                        sh 'docker tag capimg:latest hanumith/prodcapstone:latest'
                        sh 'echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin'
                        sh 'docker push hanumith/prodcapstone:latest'
                    } else if (env.BRANCH_NAME == 'Dev') {
                        sh 'docker tag capimg:latest hanumith/devcapstone:latest'
                        sh 'echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin'
                        sh 'docker push hanumith/devcapstone:latest'
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh 'chmod +x deploy.sh'
                    sh "BRANCH_NAME=${GIT_BRANCH_NAME} ./deploy.sh"
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
