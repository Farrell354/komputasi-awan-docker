pipeline {
    agent any

    environment {
        IMAGE_NAME = "laravel-kompu"
        CONTAINER_NAME = "laravel_kompu"
        PATH = "/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
    }

    stages {
        stage('Check Docker Access') {
            steps {
                sh '''
                    echo "Cek versi docker:"
                    docker --version || echo "Docker tidak ditemukan"

                    echo "Cek versi docker-compose:"
                    docker compose version || docker-compose version || echo "Docker Compose tidak ditemukan"
                '''
            }
        }

        stage('Checkout Code') {
            steps {
                git 'https://github.com/Farrell354/komputasi-awan-docker.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker compose build'
            }
        }

        stage('Run Docker Compose') {
            steps {
                sh '''
                    docker compose down || true
                    docker compose up -d
                '''
            }
        }

        stage('Verify Container Running') {
            steps {
                sh '''
                    sleep 5
                    echo "Verifikasi container berjalan..."
                    docker ps
                    curl -I http://localhost:8081 || echo "Akses ke http://localhost:8081 gagal"
                '''
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



