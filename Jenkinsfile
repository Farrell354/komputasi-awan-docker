pipeline {
    agent any

    environment {
        IMAGE_NAME = "farelmario/kompu"     // Docker Hub repo kamu
        TAG = "latest"
        VERSION_TAG = "v${env.BUILD_NUMBER}" // Tag unik berdasarkan nomor build
        CONTAINER_NAME = "laravel_app"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "🔄 Checkout source code dari GitHub..."
                git branch: 'main', url: 'https://github.com/Farrell354/komputasi-awan-docker.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🏗️ Build Docker image..."
                bat "docker build -t %IMAGE_NAME%:%TAG% ."
                bat "docker tag %IMAGE_NAME%:%TAG% %IMAGE_NAME%:%VERSION_TAG%"
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "📦 Push image ke Docker Hub..."
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat '''
                    echo ==== LOGIN KE DOCKER HUB ====
                    echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin

                    echo ==== PUSH IMAGE DENGAN TAG 'latest' ====
                    docker push %IMAGE_NAME%:%TAG%

                    echo ==== PUSH IMAGE DENGAN TAG BUILD NUMBER ====
                    docker push %IMAGE_NAME%:%VERSION_TAG%

                    echo ==== LOGOUT ====
                    docker logout
                    '''
                }
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
            echo "✅ Build & Push sukses!"
            echo "Image berhasil di-push ke Docker Hub:"
            echo " - %IMAGE_NAME%:%TAG%"
            echo " - %IMAGE_NAME%:%VERSION_TAG%"
        }
        failure {
            echo "❌ Build gagal. Cek Jenkins console output."
        }
    }
}
