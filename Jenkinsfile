pipeline {
    agent any

    environment {
        // 🧠 Define global variables
        IMAGE_NAME = 'ai-sentiment-analyzer'
        DOCKER_HUB_USER = 'patilvirupakshi'
        TELEGRAM_CHAT_ID = '5270567685'
        // You’ll securely fetch your bot token from Jenkins credentials
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo '📦 Checking out code from GitHub...'
                git branch: 'main', url: 'https://github.com/Viruthebrave/AI-Sentiment-Analyzer.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '🐳 Building Docker image...'
                bat """
                    docker build -t %DOCKER_HUB_USER%/%IMAGE_NAME%:latest .
                """
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo '📤 Pushing image to DockerHub...'
                script {
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-credentials',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        bat """
                            echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                            docker push %DOCKER_USER%/%IMAGE_NAME%:latest
                        """
                    }
                }
            }
        }

        stage('Cleanup') {
            steps {
                echo '🧹 Cleaning up Docker images...'
                bat """
                    docker rmi -f %DOCKER_HUB_USER%/%IMAGE_NAME%:latest || exit 0
                """
            }
        }
    }

    post {
        success {
            echo '✅ Build, push, and cleanup completed successfully!'
            script {
                withCredentials([string(credentialsId: 'TELEGRAM_TOKEN', variable: 'BOT_TOKEN')]) {
                    def message = "✅ SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}\n" +
                                  "Build completed successfully!\n" +
                                  "🔗 View logs: ${env.BUILD_URL}"
                    bat """
                        curl -s -X POST https://api.telegram.org/bot%BOT_TOKEN%/sendMessage -d chat_id=%TELEGRAM_CHAT_ID% -d text="${message}"
                    """
                }
            }
        }

        failure {
            echo '❌ Build failed!'
            script {
                withCredentials([string(credentialsId: 'TELEGRAM_TOKEN', variable: 'BOT_TOKEN')]) {
                    def message = "❌ FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}\n" +
                                  "Check logs for details:\n🔗 ${env.BUILD_URL}"
                    bat """
                        curl -s -X POST https://api.telegram.org/bot%BOT_TOKEN%/sendMessage -d chat_id=%TELEGRAM_CHAT_ID% -d text="${message}"
                    """
                }
            }
        }
    }
}
