pipeline {
  agent any
  stages {
    stage('Checkout from Git') {
      steps {
        stash excludes: '.git/', name: 'source_code'
      }
    }

    stage('Run tests') {
      agent {
        docker {
          image 'python:3.8.5-buster'
        }
      }
      options {
        skipDefaultCheckout()
      }
      steps {
        unstash 'source_code'
        sh './CI/run-tests.sh'
      }
    }

    stage('Parallel stages') {
      parallel {
        stage('Dockerize application') {
          environment {
            DOCKERCREDS = credentials('docker_login2')
          }
          options {
            skipDefaultCheckout()
          }
          steps {
            unstash 'source_code'
            sh './CI/push-to-docker.sh'
          }
        }
        stage('Create artifact') {
          agent {
            docker {
              image 'ubuntu'
            }
          }
          steps {
            unstash 'source_code'
            sh './CI/zip-artifact.sh'
            archiveArtifacts artifacts: 'ca-project.zip', followSymlinks: false
          }
        }
      }
    }

  }
}