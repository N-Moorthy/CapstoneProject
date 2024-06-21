pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('DOCKER_HUB_CREDENTIALS')
    }

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

        stage('Push to Docker Hub') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'Prod') {
                        sh 'docker tag devops-build_web:latest hanumith/prodcapstone:latest'
                        sh 'echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin'
                        sh 'docker push hanumith/prodcapstone:latest'
                    } else if (env.BRANCH_NAME == 'Dev') {
                        sh 'docker tag devops-build_web:latest hanumith/devcapstone:latest'
                        sh 'echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin'
                        sh 'docker push hanumith/devcapstone:latest'
                    }
                }
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

