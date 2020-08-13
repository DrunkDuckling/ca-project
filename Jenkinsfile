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
        sh 'pip install -r requirements.txt'
        sh 'python tests.py'
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
            sh 'docker build -t drunkduckling/flaskapp .'
            sh 'echo "$DOCKERCREDS_PSW" | docker login -u "$DOCKERCREDS_USR" --password-stdin'
            sh 'docker push drunkduckling/flaskapp'
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
            sh 'apt-get update -y && apt-get upgrade -y && apt-get install zip -y'
            sh 'zip -r ./ca-project.zip .'
            archiveArtifacts artifacts: 'ca-project.zip', followSymlinks: false
          }
        }
      }
    }

  }
}