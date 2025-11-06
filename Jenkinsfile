pipeline {
    agent any

    environment {
        VENV_PATH = '/opt/jenkins-tools/venv'
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
                sh '''
                    set -e

                    # Ensure venv module is installed
                    if ! python3 -m venv --help >/dev/null 2>&1; then
                        echo "Installing python3-venv..."
                        sudo apt-get update -y
                        sudo apt-get install -y python3-venv
                    fi

                    # Create venv if missing
                    if [ ! -d "$VENV_PATH" ]; then
                        echo "Creating Python virtual environment..."
                        python3 -m venv $VENV_PATH
                    fi

                    # Activate and install dependencies
                    echo "Activating virtual environment and installing dependencies..."
                    source $VENV_PATH/bin/activate
                    pip install --upgrade pip
                    pip install --no-cache-dir -r app/requirements.txt
                    deactivate
                '''
            }
        }

        stage('Unit Tests') {
            steps {
                sh '''
                source $VENV_PATH/bin/activate
                pytest app/ --maxfail=1 --disable-warnings -q
                deactivate
                '''
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
