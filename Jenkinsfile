pipeline {
    agent any 
    tools {
        maven "maven3"
    }

    stages {
        stage ("git checkout") {
            steps {
                git "https://github.com/vignesh2310/cicd-10-sep-2023.git"
            }
        }

        stage ("unit testing") {
            steps {
                sh "mvn test"
            }
        }
    }   
}


    