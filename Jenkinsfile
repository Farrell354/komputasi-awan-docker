pipeline {
    agent any

    environment {
        IMAGE_NAME = "laravel-kompu"
        CONTAINER_NAME = "laravel_kompu"
    }
    stage('Check Docker Access') {
    steps {
        sh 'echo "Cek versi docker:"'
        sh 'docker --version || echo "Docker tidak ditemukan"'
        sh 'echo "Cek status docker-compose:"'
        sh 'docker compose version || docker-compose version || echo "Docker Compose tidak ditemukan"'
    }
}


    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/Farrell354/komputasi-awan-docker.git'
            }
        }
        stage('Check Docker Access') {
    steps {
        sh 'docker ps'
        sh 'docker-compose version'
    }
}

        stage('Build Docker Image') {
            steps {
                sh 'docker-compose build'
            }
        }

        stage('Run Docker Compose') {
            steps {
                sh '''
                docker-compose down || true
                docker-compose up -d
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
            echo '✅ Laravel berhasil dijalankan via Docker Compose di port 8081!'
        }
        failure {
            echo '❌ Build gagal, cek log Jenkins console output.'
        }
    }
}


