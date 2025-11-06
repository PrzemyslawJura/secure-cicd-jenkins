pipeline {
    agent any

    environment {
        IMAGE_NAME = "secure-cicd-demo"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/PrzemyslawJura/secure-cicd-jenkins.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'pip install --no-cache-dir -r app/requirements.txt'
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'pytest app/ --maxfail=1 --disable-warnings -q'
            }
        }

        stage('Static Code Analysis - Bandit') {
            steps {
                sh './scripts/run_bandit.sh'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Container Scan - Trivy') {
            steps {
                sh './scripts/run_trivy.sh'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying container locally (optional step)...'
                // Example: run locally for demo
                sh 'docker run -d -p 5000:5000 --name secure-demo $IMAGE_NAME || true'
            }
        }
    }

    post {
        always {
            echo '🧹 Cleaning up...'
            sh 'docker rm -f secure-demo || true'
        }
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
    }
}
