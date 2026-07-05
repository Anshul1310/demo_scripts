pipeline {
    agent any

    parameters {
        string(name: 'VITE_USER_SERVICE_URL', defaultValue: 'http://nittfest.example.com/api/users', description: 'Frontend API URL for user service')
        string(name: 'VITE_ORDER_SERVICE_URL', defaultValue: 'http://nittfest.example.com/api/orders', description: 'Frontend API URL for order service')
    }

    environment {
        DOCKER_REGISTRY = 'anshul8394'
        IMAGE_TAG = "${BUILD_NUMBER}"
        GIT_REPO = 'https://github.com/Anshul1310/nittfest-webops-task2.git'
        GIT_BRANCH = 'main'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Create Frontend Env') {
            steps {
                writeFile file: 'frontend/.env', text: """\
VITE_USER_SERVICE_URL=${params.VITE_USER_SERVICE_URL}
VITE_ORDER_SERVICE_URL=${params.VITE_ORDER_SERVICE_URL}
"""
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
                sh "sed -i 's|image: ${DOCKER_REGISTRY}/frontend:.*|image: ${DOCKER_REGISTRY}/frontend:${IMAGE_TAG}|' k8s-manifests/frontend/deployment.yaml"
                sh "sed -i 's|image: ${DOCKER_REGISTRY}/user-service:.*|image: ${DOCKER_REGISTRY}/user-service:${IMAGE_TAG}|' k8s-manifests/user/deployment.yaml"
                sh "sed -i 's|image: ${DOCKER_REGISTRY}/order-service:.*|image: ${DOCKER_REGISTRY}/order-service:${IMAGE_TAG}|' k8s-manifests/order/deployment.yaml"
            }
        }

        stage('Push Manifest Changes') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github-creds', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_TOKEN')]) {
                    sh '''
                        git config user.email "negi.anshulnegi17@gmail.com"
                        git config user.name "Anshul Negi"
                        git add k8s-manifests/
                        git commit -m "ci: update image tags to build ${IMAGE_TAG}" || echo "No changes to commit"
                        git push https://${GIT_USER}:${GIT_TOKEN}@github.com/Anshul1310/nittfest-webops-task2.git HEAD:${GIT_BRANCH}
                    '''
                }
            }
        }
    }
}
