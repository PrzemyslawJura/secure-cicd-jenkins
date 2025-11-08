pipeline {
    agent any

    environment {
        VENV_PATH = "${env.WORKSPACE}/.venv"
        IMAGE_NAME = "secure-cicd-demo"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/PrzemyslawJura/secure-cicd-jenkins.git'
            }
        }

        stage('Setup Python Environment') {
            steps {
                sh '''bash -c "
                    set -e

                    echo '=== Checking Python3 installation ==='
                    if ! command -v python3 >/dev/null 2>&1; then
                        echo 'Installing Python3...'
                        sudo apt-get update -y
                        sudo apt-get install -y python3 python3-venv python3-pip
                    fi

                    echo '=== Checking virtual environment ==='
                    if [ ! -d '$VENV_PATH' ]; then
                        echo 'Creating venv at $VENV_PATH'
                        sudo mkdir -p $(dirname $VENV_PATH)
                        sudo chown -R jenkins:jenkins $(dirname $VENV_PATH)
                        python3 -m venv $VENV_PATH
                    else
                        echo 'Using existing venv'
                    fi

                    echo '=== Activating venv and installing dependencies ==='
                    source $VENV_PATH/bin/activate
                    pip install --upgrade pip
                    pip install --no-cache-dir -r app/requirements.txt
                    deactivate
                "'''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''bash -c "
                    set -e
                    source $VENV_PATH/bin/activate
                    pytest app/
                    deactivate
                "'''
            }
        }

        stage('Security Scan') {
            steps {
                sh '''bash -c "
                    set -e
                    source $VENV_PATH/bin/activate
                    ${VENV_PATH}/bin/bandit -r app/
                    deactivate
                "'''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''bash -c "
                    set -e
                    docker build -t $IMAGE_NAME .
                    "'''
            }
        }

        stage('Container Scan - Trivy') {
            steps {
                sh '''bash -c "
                    set -e
                    ./scripts/run_trivy.sh
                    "'''
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying container locally (optional step)...'
                // Example: run locally for demo
                sh '''bash -c "
                    set -e
                    docker run -d -p 5000:5000 --name secure-demo $IMAGE_NAME || true
                    "'''
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            sh '''bash -c "
                set -e
                docker rm -f secure-demo || true
                "'''
        }
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
    }
}
