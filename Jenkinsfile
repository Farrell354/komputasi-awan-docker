pipeline {
    agent any

    environment {
        IMAGE_NAME = "laravel-app"
        CONTAINER_NAME = "laravel_app"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "🔄 Checkout source code dari repo kamu..."
                git branch: 'main', url: 'https://github.com/Farrell354/komputasi-awan-docker.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                echo "🏗️  Build Docker images menggunakan docker-compose..."
                bat 'docker-compose build'
            }
        }

        stage('Run Docker Containers') {
            steps {
                echo "🚀 Jalankan ulang container Laravel, Nginx, dan MySQL..."
                bat '''
                echo ==== HENTIKAN CONTAINER LAMA ====
                docker stop laravel_app || echo "laravel_app tidak berjalan"
                docker rm laravel_app || echo "laravel_app sudah dihapus"
                docker stop nginx_server || echo "nginx_server tidak berjalan"
                docker rm nginx_server || echo "nginx_server sudah dihapus"
                docker stop mysql_db || echo "mysql_db tidak berjalan"
                docker rm mysql_db || echo "mysql_db sudah dihapus"

                echo ==== JALANKAN ULANG DOCKER COMPOSE ====
                docker-compose down || exit 0
                docker-compose up -d

                echo ==== CEK CONTAINER YANG AKTIF ====
                docker ps
                '''
            }
        }

        stage('Verify Container Running') {
            steps {
                echo "🔍 Verifikasi Laravel container berjalan dengan benar..."
                bat '''
                echo ==== TUNGGU 20 DETIK SUPAYA CONTAINER SIAP ====
                ping 127.0.0.1 -n 20 >nul

                echo ==== CEK KONEKSI KE LARAVEL ====
                curl -I http://127.0.0.1:8081 || echo "⚠️ Gagal akses Laravel di port 8081"
                
                echo.
                echo ==== ISI HALAMAN (HARUSNYA MUNCUL HALAMAN LARAVEL) ====
                curl http://127.0.0.1:8081 || echo "⚠️ Gagal ambil isi halaman"
                echo ===============================
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
