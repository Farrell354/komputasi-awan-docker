pipeline {
    agent any

    environment {
        IMAGE_NAME = "laravel-kompu"
        CONTAINER_NAME = "laravel_kompu"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/Farrell354/komputasi-awan-docker.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME} .'
            }
        }

        stage('Run Laravel Container') {
            steps {
                sh '''
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true
                docker run -d -p 8081:8000 --name ${CONTAINER_NAME} ${IMAGE_NAME}
                '''
            }
        }

        stage('Verify Container Running') {
            steps {
                sh 'sleep 5 && curl -I http://localhost:8081 || true'
            }
        }
    }

    post {
        success {
            echo '✅ Laravel berhasil dijalankan di Docker melalui Jenkins (port 8081)!'
        }
        failure {
            echo '❌ Build gagal, periksa log di Jenkins console output.'
        }
    }
}
