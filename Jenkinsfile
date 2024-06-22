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

