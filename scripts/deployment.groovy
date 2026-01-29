// Importante: No final deste ficheiro tens de retornar 'this'
def deploy(branch) {

    def imageTag = params.ROLLBACK_TAG?.trim()
            ? params.ROLLBACK_TAG
            : "${branch}-${env.BUILD_NUMBER}"

    sh 'chmod 600 deployment-resources/id_rsa_custom'

    def ssh = "ssh -F ./deployment-resources/ssh_deployment_config"

    sh """
      ${ssh} ${branch} '
        set -e
        cd /opt/genre/${branch}

        export IMAGE_TAG=${imageTag}

        docker stack deploy \
          --with-registry-auth \
          -c docker-compose-swarm.yml \
          genre
      '
    """
}

def dockerConfig(branch){
    sh 'chmod 600 deployment-resources/id_rsa_custom'

    sh """
      scp -F ./deployment-resources/ssh_deployment_config \
          docker-compose-swarm.yml \
          ${branch}:/opt/genre/${branch}
    """
}

return this