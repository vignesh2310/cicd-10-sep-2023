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
                sh "mvn verify" // creates jar files in target directory
            }
        }

        stage ("build") { // clean   - deletes the existing target directory
            steps {       // install - build and compile pom.xml file into .jar, .war files and puts in local repo
                sh "mvn clean install" // new target folder created along with jar files 
            }
        }

        stage ("build & sonarqube analysis") { // clean   - deletes the existing target directory
            steps {                            // package - build and compile pom.xml file into .jar, .war files into target folder
              withSonarQubeEnv("sonarserver") { // sonarserver - name provided in system/sonarqube servers in jenkins
                sh 'mvn clean package sonar:sonar' //
              }
            }
        }
    }   
}


    