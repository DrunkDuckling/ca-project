def remote = [:]
remote.name = "production"
remote.host = "35.187.100.28"
remote.allowAnyHosts = true

pipeline {
  agent any
  stages {
    stage('Checkout from Git') {
      steps {
        stash excludes: '.git/', name: 'source_code'
        stash includes: 'docker-compose.yml', name: 'docker-compose'
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
          when {
            branch 'master'
          }
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

    stage('Deploy') {
      when {
        branch 'master'
      }
      steps {
        unstash 'docker-compose'
        sshagent (credentials: ['testkeyssh']) {
          sh 'scp -o StrictHostKeyChecking=no docker-compose.yml ubuntu@34.76.116.98:/tmp/docker-compose.yml'
          sh 'ssh -o StrictHostKeyChecking=no ubuntu@34.76.116.98 cd /tmp/ && docker-compose down && docker-compose up -d'
        }
      }
    }
  }
}