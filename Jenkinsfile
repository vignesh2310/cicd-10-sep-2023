pipeline {
    agent any
    tools { // declaring tools for jenkins, without declaring jenkins can't find maven.
        jdk 'java11' // name given in global tool configuration
        maven 'maven3' // name given in global tool configuration
    }                  // jdk11=jenkins(default-jdk), jdk8=(open)->In pom.xml->java.version=8
    stages {
        stage('git checkout') {
            steps {
                git 'https://github.com/vignesh2310/CICD-Project.git'
            } // webhook= jenkins ip + github-webhook/
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

        stage('sonarqube-server analysis') {
            steps {
                withSonarQubeEnv('sonarserver') { // sonarserver=>name in configure=>SonarQube servers
                   sh 'mvn clean package sonar:sonar' // package=build&compile pom.xml file into (.jar, .war) files into target folder
                }
            }
        }

        stage('quality gates-sonar webhook') { // set sonar-webhook to respond back reports to jenkins
            steps {
                waitForQualityGate abortPipeline: false, credentialsId: 'sonartk'
            }
        }

        stage('nexus artifact upload') {
            steps {
                nexusArtifactUploader artifacts: [[artifactId: 'springboot', classifier: '', file: 'target/Uber.jar', type: 'jar']], credentialsId: 'nexustopken', groupId: 'com.example', nexusUrl: '54.164.40.71:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'release', version: '1.0.0'
            }     //if version=1.0(defined)=one time success, next upload with version can't done=error
        }         //so,declare build (env,build timestamp) = declare environment variables

        stage('build docker image') {
            steps {
                sh 'docker build -t $JOB_NAME:v1.$BUILD_ID .'
                sh 'docker image tag $JOB_NAME:v1.$BUILD_ID vignesh22310/$JOB_NAME:v1.$BUILD_ID'
                sh 'docker image tag $JOB_NAME:v1.$BUILD_ID vignesh22310/$JOB_NAME:latest'
            }                                      //output=vignesh22310/cicd-project:latest
        }

        stage('push to dockerhub') {
            steps{
                 withCredentials([string(credentialsId: 'docker-cicd', variable: 'docker-cicd')]) {
                     sh 'docker login -u vignesh22310 -p ${docker-cicd}'
                     sh 'docker push vignesh22310/$JOB_NAME:v1.$BUILD_ID'
                     sh 'docker push vignesh22310/$JOB_NAME:latest'
                }    
            }
        }
    }
}
