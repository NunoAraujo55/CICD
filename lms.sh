#!/bin/bash

if [ $# -lt 2 ]; then
  echo "$0 <service> <command>"
  echo "eg: $0 jenkins start"
  echo "service: jenkins, staging, db"
  echo "command: start, stop, (mongo,redis,sql)"
  exit 1
fi

service=$1
command=$2

# ENV CONFIGS
jenkins_docker="docker/jenkins-docker-compose.yml"
staging_docker="docker/staging-docker-compose.yml"

# DATABASE CONFIGS
mongodb_docker="docker/mongodb-docker-compose.yml"
redis_docker="docker/redis-docker-compose.yml"
sql_docker="docker/sql-docker-compose.yml"

#Rabbit
rabbit_docker="docker/rabbit-docker-compose.yml"

maven_version=3.9.11
maven_home=/opt/maven

jenkins-start() {
  echo "Starting jenkins docker @ $(grep -A1 "ports" $jenkins_docker | tail --lines 1 | cut -d '-' -f2)"
  docker-compose -f $jenkins_docker up -d
  echo "Jenkins Key $(docker logs --since=1h $(docker ps | grep "lms-jenkins-mvn" | cut -d' ' -f1) 2>&1 | grep -B2 "initialAdminPassword" | grep -oE "[0-9A-Za-z]{32}")"
}

jenkins-stop() {
  echo "Stopping jenkins"
  docker stop $(docker ps | grep "lms-jenkins-mvn" | cut -d' ' -f1)
}

jenkins-maven() {
  docker_container=$(docker ps | grep "lms-jenkins-mvn" | cut -d' ' -f1)
  docker exec -it "${docker_container}" rm apache*
  docker exec -it "${docker_container}" apt-get update
  docker exec -it "${docker_container}" apt-get install -y wget
  docker exec -it "${docker_container}" wget https://downloads.apache.org/maven/maven-3/${maven_version}/binaries/apache-maven-${maven_version}-bin.tar.gz
  docker exec -it "${docker_container}" tar -xzvf apache-maven-${maven_version}-bin.tar.gz -C /opt
  docker exec -it "${docker_container}" ln -s /opt/apache-maven-${maven_version} ${maven_home}
  docker exec -it "${docker_container}" ln -s ${maven_home}/bin/mvn /usr/bin/mvn
}

staging-start(){
	echo "Starting staging docker @ $(grep -A1 "ports" $staging_docker | tail --lines 1 | cut -d '-' -f2)"
  docker-compose -f $staging_docker up -d
}

staging-stop(){
	echo "Stopping staging"
  docker stop $(docker ps | grep "lms-staging" | cut -d' ' -f1)
}

db(){
  local db_type=$1
  case "$db_type" in
    mongo)
      docker-compose -f $mongodb_docker up -d
      ;;
    redis)
      docker-compose -f $redis_docker up -d
      ;;
    sql)
      docker-compose -f $sql_docker up -d
      ;;
    *)
      echo "mongo/redis/sql"
      ;;
  esac
}

rabbit() {
  case "$1" in
    start|up)
      docker-compose -f $rabbit_docker up -d
      ;;
    stop|down)
      docker-compose -f $rabbit_docker down
      ;;
    restart)
      docker-compose -f $rabbit_docker down
      docker-compose -f $rabbit_docker up -d
      ;;
    *)
      echo "Usage: $0 rabbit {start|stop|restart}"
      ;;
  esac
}

case "$service" in
  jenkins)
    case "$command" in
      start)
        jenkins-start
        ;;
      stop)
        jenkins-stop
        ;;
      restart)
        jenkins-stop
        jenkins-start
        ;;
      maven)
        jenkins-maven
        ;;
      *)
        echo "Invalid command for Jenkins. Use: start|stop|restart|maven"
        exit 1
        ;;
    esac
    ;;

  staging)
    case "$command" in
      start)
        staging-start
        ;;
      stop)
        staging-stop
        ;;
      restart)
        staging-stop
        staging-start
        ;;
      *)
        echo "Invalid command for staging. Use: start|stop|restart"
        exit 1
        ;;
    esac
    ;;

  db)
    db "$command"
    ;;

  rabbit)
    rabbit "$command"
    ;;

  *)
    echo "Unknown service!"
    exit 1
    ;;
esac