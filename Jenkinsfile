pipeline {
    agent any
    stages {
        stage('git checkout') {
            steps {
                git 'https://github.com/vignesh2310/CICD-Project.git'
            }
        }
        
        stage('unit test') {
            steps {
                sh 'mvn test'
            }
        }
    }
}