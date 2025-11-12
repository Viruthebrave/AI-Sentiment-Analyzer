pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'patilvirupakshi'
        IMAGE_NAME = 'ai-sentiment-analyzer'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Viruthebrave/AI-Sentiment-Analyzer.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    bat """
                        docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest .
                    """
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                        bat """
                            echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                            docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest
                        """
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                bat """
                    docker rmi -f ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest || exit 0
                """
            }
        }
    }

    post {
        success {
            echo '✅ Build, push, and cleanup completed successfully!'
        }
        failure {
            echo '❌ Build failed! Check console logs for details.'
        }
    }
}
