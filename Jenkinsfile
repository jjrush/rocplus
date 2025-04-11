pipeline {
    agent {
        label {
            label 'rhel9'
        }
    }
    stages {
        stage('Build') {
            agent {
                docker { 
                    image 'ghcr.io/hanspeterson33/zeek:latest'
                    args '--user root --entrypoint='
                }
            }

            steps {
                sh """
                    rm -rf build
                    mkdir build
                    cd build

                    cmake ..
                    cmake --build . -j \$(nproc)
                """
            }
        }
    }
}