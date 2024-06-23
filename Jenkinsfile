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
                    // Determine branch to checkout
                    def branch = env.BRANCH_NAME ?: sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()
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
            when {
                expression {
                    // Only push Docker images for 'Prod' or 'Dev' branches
                    env.BRANCH_NAME == 'Prod' || env.BRANCH_NAME == 'Dev'
                }
            }
            steps {
                script {
                    echo "Branch name is: ${env.BRANCH_NAME}"
                    
                    // Docker push based on branch
                    def dockerRepo
                    if (env.BRANCH_NAME == 'Prod') {
                        dockerRepo = 'hanumith/prodcapstone'
                    } else if (env.BRANCH_NAME == 'Dev') {
                        dockerRepo = 'hanumith/devcapstone'
                    } else {
                        error "Unsupported branch for Docker push: ${env.BRANCH_NAME}"
                    }
                    
                    sh '''
                        docker tag capimg:latest ${dockerRepo}:latest
                        echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin
                        docker push ${dockerRepo}:latest
                    '''
                }
            }
        }
        
        stage('Deploy') {
            when {
                expression {
                    // Only deploy if branch is 'Prod' or 'Dev'
                    env.BRANCH_NAME == 'Prod' || env.BRANCH_NAME == 'Dev'
                }
            }
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
