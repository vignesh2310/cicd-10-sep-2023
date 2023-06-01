pipeline {
    agent any
    tools { // declaring tools for jenkins, without declaring jenkins can't find maven.
        jdk 'java8' // name given in global tool configuration
        maven 'maven3' // name given in global tool configuration
    }                  // jdk11=jenkins(default-jdk), jdk8=(open)->In pom.xml->java.version=8
    stages {
        stage('git checkout') {
            steps {
                git 'https://github.com/vignesh2310/CICD-Project.git'
            }
        }
        
        stage('unit test') {
            steps {
                sh 'mvn test' // mvn test=run test cases of project
            }
        }

        stage('integration test') {
            steps {
                sh 'mvn verify -DskipUnitTests' // mvn verify=integration testing to ensure quality criteria are met
            }
        }

        stage('maven build') {
            steps {
                sh 'mvn clean install' // clean=deletes previous compiled files(target directory)
            }                          // install=build&compile pom.xml file into (.jar, .war) files in local repo
        }

        stage('sonarqube analysis') {
            steps {
                withSonarQubeEnv('sonartoken') {
                   sh 'mvn clean package sonar:sonar' // package=build&compile pom.xml file into (.jar, .war) files into target folder
                }
            }
        }
    }
}