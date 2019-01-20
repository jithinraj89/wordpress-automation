def call(body) {

        def config = [:]
        def PATH = "/var/lib/jenkins/workspace"
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
                                sh "cd ${PATH} && sudo ls README.md"
                            }
                        }
                    }
                }
            }
        }
}
