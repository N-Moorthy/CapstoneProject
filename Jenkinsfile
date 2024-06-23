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
            steps {
                script {
                    echo "Branch name is: ${env.BRANCH_NAME}"
                    if (env.BRANCH_NAME == 'Prod') {
                        echo 'Pushing to Prod repository'
                        sh '''
                            docker tag capimg:latest hanumith/prodcapstone:latest
                            echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin
                            docker push hanumith/prodcapstone:latest
                        '''
                    } else if (env.BRANCH_NAME == 'Dev') {
                        echo 'Pushing to Dev repository'
                        sh '''
                            docker tag capimg:latest hanumith/devcapstone:latest
                            echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin
                            docker push hanumith/devcapstone:latest
                        '''
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
