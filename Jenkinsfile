#!/usr/bin/env groovy
@Library('github.com/msrb/cicd-pipeline-helpers') _

node('docker') {

    def image = docker.image('bayesian/cvedb-s3-dump')

    stage('Checkout') {
        checkout scm
    }

    stage('Build') {
        dockerCleanup()
        docker.build(image.id, '--pull --no-cache .')
    }

    if (env.BRANCH_NAME == 'master') {
        stage('Push Images') {
            def commitId = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
            docker.withRegistry('https://registry.devshift.net/') {
                image.push('latest')
                image.push(commitId)
            }
        }
    }
}
