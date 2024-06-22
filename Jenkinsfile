pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('DOCKER_HUB_CREDENTIALS')
	BRANCH_NAME = 'Dev'
        GIT_REPO_URL = 'https://github.com/N-Moorthy/CapstoneProject.git'
        GIT_CREDENTIALS_ID = '3c5cf833-313a-4c9a-bf52-3e2609df6860'
    }
    
    stages {
         stage('Checkout SCM') {
            steps {
                script {
                    // Ensure BRANCH_NAME is set, defaulting to 'Dev' if not specified
                    def branch = BRANCH_NAME ?: 'Dev'
                    echo "Checking out branch: ${branch}"
                    
                    // Checkout SCM using Git plugin
                    checkout([$class: 'GitSCM',
                              branches: [[name: "*/${branch}"]],
                              doGenerateSubmoduleConfigurations: false,
                              extensions: [],
                              userRemoteConfigs: [[url: GIT_REPO_URL,
                                                   credentialsId: GIT_CREDENTIALS_ID]]])
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
