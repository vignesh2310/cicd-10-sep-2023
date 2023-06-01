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

        stage('sonarqube-server analysis') {
            steps {
                withSonarQubeEnv('sonarserver') { // sonarserver=>name in configure=>SonarQube servers
                   sh 'mvn clean package sonar:sonar' // package=build&compile pom.xml file into (.jar, .war) files into target folder
                }
            }
        }

        stage('quality gates-sonar webhook') { // set sonar-webhook to respond back reports to jenkins
            steps {
                waitForQualityGate abortPipeline: false, credentialsId: 'sonartoken'
            }
        }

        stage('nexus artifact upload') {
            steps {
                nexusArtifactUploader artifacts: 
                [
                    [
                        artifactId: 'springboot', // artifact id in pom.xml
                        classifier: '',
                        file: 'target/Uber.jar', // file path in jenkins server
                        type: 'jar' 
                    ]
                ],
                        credentialsId: 'nexus-cred', 
                        groupId: 'com.example', // group id in pom.xml
                        nexusUrl: '13.59.5.165:8081', // public.ip with port 8081
                        nexusVersion: 'nexus3',
                        protocol: 'http',
                        repository: 'spring-release', // nexus maven(hosted) repo name
                        version: "${env.BUILD_ID}-${env.BUILD_TIMESTAMP}" 
            }     //if version=1.0(defined)=one time success, next upload with version can't done=error
        }         //so,declare build (env,build timestamp) = declare environment variables

        stage('build docker image') {
            steps {
                sh 'docker build -t $JOB_NAME:v1.$BUILD_ID .'
                sh 'docker image tag $JOB_NAME:v1.$BUILD_ID vignesh22310/$JOB_NAME:v1.$BUILD_ID'
                sh 'docker image tag $JOB_NAME:v1.$BUILD_ID vignesh22310/$JOB_NAME:latest'
            }                                             //vignesh22310/cicd-project:latest
        }

        stage('push to dockerhub') {
            steps {
                   sh 'docker login -u vignesh22310 -p Mark42@ps'
                   sh 'docker push vignesh22310/$JOB_NAME:v1.$BUILD_ID'
                   sh 'docker push vignesh22310/$JOB_NAME:latest'
                }
            }
        }
    }
}