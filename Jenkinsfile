pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'anshul8394'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Images') {
            steps {
                sh 'docker build -t ${DOCKER_REGISTRY}/frontend:${IMAGE_TAG} ./frontend'
                sh 'docker build -t ${DOCKER_REGISTRY}/user-service:${IMAGE_TAG} ./backend/user-service'
                sh 'docker build -t ${DOCKER_REGISTRY}/order-service:${IMAGE_TAG} ./backend/order-service'
            }
        }

        stage('Push Images') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push ${DOCKER_REGISTRY}/frontend:${IMAGE_TAG}'
                    sh 'docker push ${DOCKER_REGISTRY}/user-service:${IMAGE_TAG}'
                    sh 'docker push ${DOCKER_REGISTRY}/order-service:${IMAGE_TAG}'
                }
            }
        }

        stage('Update K8s Manifests') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-creds', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
                    sh '''
                        rm -rf demo_scripts
                        git clone https://${GIT_USER}:${GIT_TOKEN}@github.com/Anshul1310/demo_scripts.git
                    '''
                }
                sh "sed -i 's|image: ${DOCKER_REGISTRY}/frontend:.*|image: ${DOCKER_REGISTRY}/frontend:${IMAGE_TAG}|' demo_scripts/frontend/deployment.yaml"
                sh "sed -i 's|image: ${DOCKER_REGISTRY}/user-service:.*|image: ${DOCKER_REGISTRY}/user-service:${IMAGE_TAG}|' demo_scripts/user/deployment.yaml"
                sh "sed -i 's|image: ${DOCKER_REGISTRY}/order-service:.*|image: ${DOCKER_REGISTRY}/order-service:${IMAGE_TAG}|' demo_scripts/order/deployment.yaml"
            }
        }

        stage('Push Manifest Changes') {
            steps {
                sh '''
                    cd demo_scripts
                    git config user.email "negi.anshulnegi17@gmail.com"
                    git config user.name "Anshul Negi"
                    git add .
                    git commit -m "ci: update image tags to build ${IMAGE_TAG}" || echo "No changes to commit"
                    git push origin main
                '''
            }
        }
    }
}
