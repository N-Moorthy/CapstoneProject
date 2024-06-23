pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockercreds')
        GIT_REPO_URL = 'https://github.com/N-Moorthy/CapstoneProject.git'
        GIT_CREDENTIALS_ID = 'gitcreds'
        BRANCH_NAME = env.BRANCH_NAME ?: 'Prod'
    }
    
    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    echo "Checking out branch: ${BRANCH_NAME}"
                    
                    // Checkout SCM using Git plugin
                    checkout([$class: 'GitSCM',
                              branches: [[name: "*/${BRANCH_NAME}"]],
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
                    // Ensure Docker BuildKit is enabled
                    sh 'export DOCKER_BUILDKIT=1'
                    sh 'chmod +x build.sh'
                    sh './build.sh'
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    def imageName = (BRANCH_NAME == 'Prod') ? 'hanumith/prodcapstone:latest' : 'hanumith/devcapstone:latest'
                    
                    sh "docker tag capimg:latest ${imageName}"
                    sh 'echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin'
                    sh "docker push ${imageName}"
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Ensure Docker Compose is updated and compatible
                    sh 'docker-compose version'
                    sh 'docker-compose down'
                    sh 'chmod +x deploy.sh'
                    sh "./deploy.sh ${BRANCH_NAME}"
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
