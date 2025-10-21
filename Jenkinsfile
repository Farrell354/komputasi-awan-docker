pipeline {
    agent any

    environment {
        IMAGE_NAME = "farrell354/laravel-app"
        CONTAINER_NAME = "laravel_app"
        REGISTRY_CREDENTIALS = "dockerhub-credentials"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo '📥 Mengambil source code Laravel dari GitHub...'
                git branch: 'main', url: 'https://github.com/Farrell354/komputasi-awan-docker.git'
            }
        }

        stage('Build Docker Images') {
            steps {
                echo '⚙️ Membuat Docker images untuk Laravel, Nginx, dan MySQL...'
                bat 'docker-compose build'
            }
        }

        stage('Run Unit Tests (PHPUnit)') {
            steps {
                echo '🧪 Menjalankan unit test Laravel menggunakan PHPUnit di container...'
                bat '''
                docker-compose run --rm laravel_app vendor\\bin\\phpunit -q || exit /b 1
                '''
            }
        }

        stage('Push Docker Image to Docker Hub') {
            when {
                expression { currentBuild.resultIsBetterOrEqualTo('SUCCESS') }
            }
            steps {
                echo '🚀 Push image Laravel ke Docker Hub...'
                withCredentials([usernamePassword(credentialsId: env.REGISTRY_CREDENTIALS, usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    bat """
                        docker login -u %USER% -p %PASS%
                        docker tag laravel_app ${env.IMAGE_NAME}:${env.BUILD_NUMBER}
                        docker push ${env.IMAGE_NAME}:${env.BUILD_NUMBER}
                        docker tag ${env.IMAGE_NAME}:${env.BUILD_NUMBER} ${env.IMAGE_NAME}:latest
                        docker push ${env.IMAGE_NAME}:latest
                        docker logout
                    """
                }
            }
        }

        stage('Run Docker Containers') {
            steps {
                echo '🐳 Menjalankan ulang container Laravel melalui Docker Compose...'
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
                echo '🔍 Verifikasi apakah Laravel berjalan dengan benar di port 8081...'
                bat '''
                echo ==== TUNGGU 20 DETIK UNTUK SIAP ====
                ping 127.0.0.1 -n 20 >nul

                echo ==== CEK KONEKSI KE LARAVEL ====
                curl -I http://127.0.0.1:8081 || echo "⚠️ Gagal akses Laravel di port 8081"

                echo.
                echo ==== CEK ISI HALAMAN ====
                curl http://127.0.0.1:8081 || echo "⚠️ Tidak bisa ambil isi halaman"
                echo ==========================================
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline sukses! Laravel berhasil dijalankan di http://127.0.0.1:8081.'
        }
        failure {
            echo '❌ Pipeline gagal — silakan cek error log di Jenkins console output.'
        }
        always {
            echo '🕓 Pipeline selesai dijalankan.'
        }
    }
}
