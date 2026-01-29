def utils
def containerPush
def deployment
def release

def config = [
    'Staging':'staging',
    'Production':'production'
]

pipeline {
    agent any

    parameters {
        string(
            name: 'ROLLBACK_TAG',
            defaultValue: '',
            description: 'Docker image tag to rollback to (e.g. staging-12)'
        )
        choice(
            name: 'DEPLOY_ENV',
            choices: ['Staging', 'Production'],
            description: 'Para qual ambiente queres fazer o deploy?'
        )
    }

    stages {
        stage('Prepare') {
            steps {
                script {
                    utils = load 'scripts/utils.groovy'
                    containerPush = load 'scripts/container_push.groovy'
                    deployment = load 'scripts/deployment.groovy'
                    release = load 'scripts/release.groovy'
                }
            }
        }

        stage('Initialize') {
            steps {
                script {
                    utils.sendNotification('#f0544c',
                    "🚀 *Started:* Job ${env.JOB_NAME} [Build #${env.BUILD_NUMBER}] (<${env.BUILD_URL}|Check Console>)")
                }
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
                sh 'mvn clean'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Tests') {
            steps {
                sh 'mvn test -DskipITs'
                sh 'mvn verify -DskipUTs'
            }
        }

        stage('Mutation tests') {
            steps {
                script {
                    try {
                        sh 'mvn org.pitest:pitest-maven:mutationCoverage'
                    } finally {
                        utils.publishReport(
                            path: 'target/pit-reports',
                            file: 'index.html',
                            name: "Mutation Tests (PIT)"
                        )
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonarqube-token', variable: 'SONAR_TOKEN')]) {
                    sh "mvn verify -DskipUTs -DskipITs org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -Dsonar.projectKey=psoft-g1 -Dsonar.projectName='psoft-g1' -Dsonar.host.url='http://lms-isep.ovh:9000' -Dsonar.token=${SONAR_TOKEN}"
                }
            }
        }

        stage('Post-Build Reports') {
            steps {
                script {
                    utils.publishReport(path: 'target/site/jacoco', file: 'index.html', name: "JaCoCo Coverage")
                        sh '''
                            mvn \
                              -Dtest="**/*CDC*Test" \
                              -Dit.test="**/*CDC*IT" \
                              verify
                        '''
                    utils.publishReport(path: 'target/pacts', file: '*.html', name: "Pact Contract Tests")
                }
            }
        }

        stage('Push container to dockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    script {
                        containerPush.containerPush("${config[params.DEPLOY_ENV]}-${env.BUILD_NUMBER}", DOCKER_USER, DOCKER_PASS)
                    }
                }
            }
        }

        stage("Deploy Docker Struct"){
            steps{
                script{
                    deployment.dockerConfig(config[params.DEPLOY_ENV])
                }
            }
        }

        stage("Deploy") {
            steps {
                script {
                    deployment.deploy(config[params.DEPLOY_ENV])
                }
            }
        }

        stage('Wait for API') {
          steps {
            script {
              timeout(time: 3, unit: 'MINUTES') {
                waitUntil {
                  sh(
                    script: 'curl -sf http://141.227.165.115/api/genres',
                    returnStatus: true
                  ) == 0
                }
              }
            }
          }
        }

        stage('k6 Production Load Tests') {
            steps {
                script {
                    withEnv(["BUILD_NUMBER=${env.BUILD_NUMBER}"]) {
                        utils.runLoadTest("load-tests/smoke/get-genres-smoke.js", 'K6 Smoke Get Books Report')
                        currentBuild.result = 'SUCCESS'
                    }
                }
            }
        }
    }

    post {
        unstable {
            script { utils.sendNotification('#ffcc00', "Build com avisos (k6), mas o Deploy foi feito!") }
        }
        success {
            script { utils.sendNotification('#f0544c', "Sucesso total!") }
        }
        failure {
            script { utils.sendNotification('danger', "Algo correu mal...") }
        }
    }
}