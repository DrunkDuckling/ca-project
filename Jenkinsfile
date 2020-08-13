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
        stage('Create artifct') {
          steps {
            sh 'echo Making artifact'
          }
        }
      }
    }

  }
}