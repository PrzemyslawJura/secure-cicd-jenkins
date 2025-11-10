pipeline {
    agent any

    environment {
        VENV_PATH = "${env.WORKSPACE}/.venv"
        VENV_ACTIVATE_PATH = "${VENV_PATH}/bin/activate"
        REQUIREMENTS_PATH = "app/requirements.txt"
        IMAGE_NAME = "secure-cicd-demo"
        TEST_PATH = "app/"
        TRIVY_PATH = "scripts/run_trivy.sh"
        BANDIT_PATH = "scripts/run_bandit.sh"

        NULL_DEVICE = "/dev/null"
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
                    if ! command -v python3 >"${NULL_DEVICE}" 2>&1; then
                        echo 'Installing Python3...'
                        apt-get update -y
                        apt-get install -y python3 python3-venv python3-pip
                    fi

                    echo '=== Checking virtual environment ==='
                    if [ ! -d '"${VENV_PATH}"' ]; then
                        echo 'Creating venv at "${VENV_PATH}"'
                        mkdir -p $(dirname "${VENV_PATH}")
                        chown -R jenkins:jenkins $(dirname "${VENV_PATH}")
                        python3 -m venv "${VENV_PATH}"
                    else
                        echo 'Using existing venv'
                    fi

                    echo '=== Activating venv and installing dependencies ==='
                    ${VENV_PATH}/bin/pip install --upgrade pip
                    ${VENV_PATH}/bin/pip install --no-cache-dir -r "${REQUIREMENTS_PATH}"
                "'''
            }
        }

        stage('Run Tests') {
            steps {
                sh '''bash -c "
                    set -e
                    "${VENV_PATH}/bin/pytest" "${TEST_PATH}"
                "'''
            }
        }

        stage('Security Scan') {
            steps {
                sh '''bash -c "
                    set -e
                    source "${VENV_ACTIVATE_PATH}"
                    chmod u+x "${BANDIT_PATH}"
                    "${BANDIT_PATH}"
                    deactivate
                "'''
                archiveArtifacts artifacts: "bandit-report.html", fingerprint: true
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''bash -c "
                    set -e
                    docker build -t "$IMAGE_NAME" --cache-from="${IMAGE_NAME}" .
                    "'''
            }
        }

        stage('Container Scan - Trivy') {
            steps {
                sh '''bash -c "
                    set -e
                    chmod u+x "${TRIVY_PATH}"
                    "${TRIVY_PATH}"
                    "'''
                archiveArtifacts artifacts: "trivy-report.json", fingerprint: true
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying container locally (optional step)...'
                // Example: run locally for demo
                sh '''bash -c "
                    set -e
                    docker run -d -p 5000:5000 --name secure-demo "${IMAGE_NAME}" || true
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
                docker system prune -f || true
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
