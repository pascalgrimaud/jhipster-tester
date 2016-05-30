#!/bin/bash

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
runContainer() {
    local application="$1"
    docker run \
        -d --name $application --label=test \
        -v "$JHIPSTER_TRAVIS"/samples/"$application":/home/jhipster/volume/app:ro \
        -v "$HOME"/.m2:/home/jhipster/volume/.m2:ro \
        -v "$TRAVIS_BUILD_DIR":/home/jhipster/volume/generator-jhipster:ro \
        -t jhipster-tester
}

runContainerNoDaemon() {
    local application="$1"
    docker run \
        --name $application --label=test \
        -v "$JHIPSTER_TRAVIS"/samples/"$application":/home/jhipster/volume/app:ro \
        -v "$HOME"/.m2:/home/jhipster/volume/.m2:ro \
        -v "$TRAVIS_BUILD_DIR":/home/jhipster/volume/generator-jhipster:ro \
        -t jhipster-tester
}

runContainerSkipFront() {
    local application="$1"
    docker run \
        -d --name $application --label=test \
        -v "$JHIPSTER_TRAVIS"/samples/"$application":/home/jhipster/volume/app:ro \
        -v "$HOME"/.m2:/home/jhipster/volume/.m2:ro \
        -v "$TRAVIS_BUILD_DIR":/home/jhipster/volume/generator-jhipster:ro \
        -e JHIPSTER_TEST_FRONT=0
        -t jhipster-tester
}

#-------------------------------------------------------------------------------

cd "$JHIPSTER_TRAVIS"
runContainerNoDaemon app-mysql
# runContainer app-psql-es-noi18n
# runContainer app-mongodb
# runContainer app-cassandra
# runContainer app-gateway
# runContainer app-hazelcast-cucumber
