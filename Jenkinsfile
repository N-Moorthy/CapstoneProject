pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockercreds')
        GIT_REPO_URL = 'https://github.com/N-Moorthy/CapstoneProject.git'
        GIT_CREDENTIALS_ID = 'gitcreds'
    }
    
    stages {
        stage('Checkout SCM') {
            steps {
                script {
                    // Ensure BRANCH_NAME is set, defaulting to 'Dev' if not specified
                    def branch = env.BRANCH_NAME ?: 'Dev'
                    echo "Checking out branch: ${branch}"
                    
                    // Checkout SCM using Git plugin
                    checkout([$class: 'GitSCM',
                              branches: [[name: "${branch}"]],
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
                    echo "Branch name is: ${env.BRANCH_NAME}"
                    if (env.BRANCH_NAME == 'Prod') {
                        echo 'Pushing to Prod repository'
                        sh 'docker tag capimg:latest hanumith/prodcapstone:latest'
                        sh 'echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin'
                        sh 'docker push hanumith/prodcapstone:latest'
                    } else if (env.BRANCH_NAME == 'Dev') {
                        echo 'Pushing to Dev repository'
                        sh 'docker tag capimg:latest hanumith/devcapstone:latest'
                        sh 'echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin'
                        sh 'docker push hanumith/devcapstone:latest'
                    } else {
                        echo 'Branch is not Prod or Dev. Skipping Docker push.'
                    }
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    sh 'docker-compose down'  
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
