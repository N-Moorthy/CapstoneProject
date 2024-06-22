pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('DOCKER_HUB_CREDENTIALS')
	GIT_BRANCH_NAME = ''
    }
	stages {
        stage('Checkout SCM') {
            steps {
                script {
                    checkout scm
                    // Retrieve the branch name from the environment variable provided by Jenkins
                    GIT_BRANCH_NAME = sh(script: 'echo ${env.BRANCH_NAME}', returnStdout: true).trim()
                    echo "Checked out branch: ${GIT_BRANCH_NAME}"
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
