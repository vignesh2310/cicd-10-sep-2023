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

        stage ("unit testing") { // run test cases of project, test compiled source code with suitable unit test framework 
            steps {
                sh "mvn test" // target file is created in jenkins server
            }
        }

        stage ("integration testing") { // performs integration test, This command builds the project, runs all the test cases to ensure quality criteria are met
            steps {
                sh "mvn verify"
            }
        }
    }   
}


    