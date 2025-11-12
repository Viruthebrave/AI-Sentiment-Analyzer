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
                    docker.build("${DOCKER_HUB_USER}/${IMAGE_NAME}:latest")
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials') {
                        docker.image("${DOCKER_HUB_USER}/${IMAGE_NAME}:latest").push()
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                sh 'docker system prune -f'
            }
        }
    }

    post {
        success {
            echo '🎉 Successfully built and pushed image to DockerHub!'
        }
        failure {
            echo '❌ Build failed! Check console logs.'
        }
    }
}
