def call(body) {

        def config = [:]
        def PLAYBOOK_PATH = "/var/lib/jenkins/workspace/Jenkins_Deployments"
        body.resolveStrategy = Closure.DELEGATE_FIRST
        body.delegate = config
        
        body()

        pipeline {
            agent {
                label 'master'
            }
            
             parameters {
                choice(
                    // choices are a string of newline separated values
                    choices: 'rabbitmq\nredis\ntusker\npheme\ndroms\nopenadr2b\nceep\ndianoga\ncascade\nrtcc\nfam-backend\nall',
                    description: '',
                    name: 'REQUESTED_ACTION')
            }

            stages {
                stage ('rabbitmq') {
                    
                    steps {
                        script {
                            if (params.REQUESTED_ACTION == 'rabbitmq'){
                                echo 'Depoying rabbitmq '
                                sh "cd ${PLAYBOOK_PATH}/${config.jobName}/ansible/playbooks/${config.folderName} && sudo cp ~/ansible.cfg ansible.cfg && sudo ansible-playbook -i ${PLAYBOOK_PATH}/${config.jobName}/ansible/playbooks/${config.folderName}/inventory/${config.inventoryFolder}/${config.envName} ${PLAYBOOK_PATH}/${config.jobName}/ansible/playbooks/${config.folderName}/rabbitmq.yml --tags ${config.tagName} --vault-password-file  ~/.agv"
                            }
                        }
                    }
                }


