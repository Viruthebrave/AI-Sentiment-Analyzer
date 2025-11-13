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
                bat "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest ."
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
                bat "docker rmi -f ${DOCKER_HUB_USER}/${IMAGE_NAME}:latest || exit 0"
            }
        }
    }

    post {
        success {
            echo '✅ Build, push, and cleanup completed successfully!'
            emailext (
                subject: "✅ SUCCESS: Jenkins Build - ${env.JOB_NAME}",
                body: """
                <h3>🎉 Jenkins Build Successful!</h3>
                <p><b>Project:</b> ${env.JOB_NAME}</p>
                <p><b>Build #:</b> ${env.BUILD_NUMBER}</p>
                <p><b>Status:</b> SUCCESS ✅</p>
                <p>View details: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                """,
                to: 'yourgmail@gmail.com',
                mimeType: 'text/html'
            )
        }
        failure {
            echo '❌ Build failed! Check console logs.'
            emailext (
                subject: "❌ FAILED: Jenkins Build - ${env.JOB_NAME}",
                body: """
                <h3>⚠️ Jenkins Build Failed!</h3>
                <p><b>Project:</b> ${env.JOB_NAME}</p>
                <p><b>Build #:</b> ${env.BUILD_NUMBER}</p>
                <p><b>Status:</b> FAILURE ❌</p>
                <p>View logs: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                """,
                to: 'yourgmail@gmail.com',
                mimeType: 'text/html'
            )
        }
    }
}
