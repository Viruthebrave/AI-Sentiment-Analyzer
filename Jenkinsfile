pipeline {
    agent any

    environment {
        IMAGE_NAME = "ai-sentiment-analyzer"
        DOCKER_USER = "patilvirupakshi"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "📦 Checking out code from GitHub..."
                git branch: 'main', url: "https://github.com/Viruthebrave/AI-Sentiment-Analyzer.git"
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image..."
                bat """
                    docker build -t %DOCKER_USER%/%IMAGE_NAME%:latest .
                """
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo "📤 Pushing image to DockerHub..."
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DH_USER',
                        passwordVariable: 'DH_PASS'
                    )]) {
                        bat """
                            echo %DH_PASS% | docker login -u %DH_USER% --password-stdin
                            docker push %DH_USER%/%IMAGE_NAME%:latest
                        """
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                echo "🧹 Cleaning up Docker images..."
                bat """
                    docker rmi -f %DOCKER_USER%/%IMAGE_NAME%:latest || exit 0
                """
            }
        }
    }

    post {
        success {
            echo "✅ Build and push completed successfully!"
        }
        failure {
            echo "❌ Build failed! Check logs."
        }
    }
}
