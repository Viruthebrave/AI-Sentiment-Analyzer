pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = "patilvirupakshi"
        IMAGE_NAME = "ai-sentiment-analyzer"
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "📦 Checking out code from GitHub..."
                git branch: 'main', url: 'https://github.com/Viruthebrave/AI-Sentiment-Analyzer.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image..."
                bat """
                docker build -t %DOCKER_HUB_USER%/%IMAGE_NAME%:latest .
                """
            }
        }

        stage('Push to DockerHub') {
            steps {
                echo "📤 Pushing image to DockerHub..."
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
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
                docker rmi -f %DOCKER_HUB_USER%/%IMAGE_NAME%:latest || exit 0
                """
            }
        }
    }

    post {

        success {
            echo "Build succeeded. Sending Telegram notification..."
            withCredentials([string(credentialsId: 'BOT_TOKEN', variable: 'TOKEN')]) {
                bat """
                curl -s -X POST https://api.telegram.org/bot%TOKEN%/sendMessage ^
                -d chat_id=5270567685 ^
                -d text="SUCCESS: AI-Sentiment-CI-CD Build #%BUILD_NUMBER%25%0AView logs: http://localhost:8080/job/AI-Sentiment-CI-CD/%BUILD_NUMBER%/"
                echo Success notification sent to Telegram.
                """
            }
        }

        failure {
            echo "Build failed. Sending Telegram notification..."
            withCredentials([string(credentialsId: 'BOT_TOKEN', variable: 'TOKEN')]) {
                bat """
                curl -s -X POST https://api.telegram.org/bot%TOKEN%/sendMessage ^
                -d chat_id=5270567685 ^
                -d text="FAILURE: AI-Sentiment-CI-CD Build #%BUILD_NUMBER%25%0ACheck logs: http://localhost:8080/job/AI-Sentiment-CI-CD/%BUILD_NUMBER%/"
                echo Failure notification sent to Telegram.
                """
            }
        }
    }
}
