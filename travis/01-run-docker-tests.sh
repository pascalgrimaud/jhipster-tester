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
        -e JHIPSTER_REPO_URL=https://github.com/pascalgrimaud/generator-jhipster.git \
        -e JHIPSTER_REPO_BRANCH=master \
        -t jhipster-tester
}

runContainerNoDaemon() {
    local application="$1"
    docker run \
        --name $application --label=test \
        -v "$JHIPSTER_TRAVIS"/samples/"$application":/home/jhipster/volume/app:ro \
        -v "$HOME"/.m2:/home/jhipster/volume/.m2:ro \
        -v "$TRAVIS_BUILD_DIR":/home/jhipster/volume/generator-jhipster:ro \
        -e JHIPSTER_REPO_URL=https://github.com/pascalgrimaud/generator-jhipster.git \
        -e JHIPSTER_REPO_BRANCH=master \
        -t jhipster-tester
}

runContainerSkipFront() {
    local application="$1"
    docker run \
        -d --name $application --label=test \
        -v "$JHIPSTER_TRAVIS"/samples/"$application":/home/jhipster/volume/app:ro \
        -v "$HOME"/.m2:/home/jhipster/volume/.m2:ro \
        -v "$TRAVIS_BUILD_DIR":/home/jhipster/volume/generator-jhipster:ro \
        -e JHIPSTER_REPO_URL=https://github.com/pascalgrimaud/generator-jhipster.git \
        -e JHIPSTER_REPO_BRANCH=master \
        -e JHIPSTER_TEST_FRONT=0 \
        -e JHIPSTER_TEST_PACKAGING=0 \
        -t jhipster-tester
}

runContainerSkipFrontNoDaemon() {
    local application="$1"
    docker run \
        --name $application --label=test \
        -v "$JHIPSTER_TRAVIS"/samples/"$application":/home/jhipster/volume/app:ro \
        -v "$HOME"/.m2:/home/jhipster/volume/.m2:ro \
        -v "$TRAVIS_BUILD_DIR":/home/jhipster/volume/generator-jhipster:ro \
        -e JHIPSTER_REPO_URL=https://github.com/pascalgrimaud/generator-jhipster.git \
        -e JHIPSTER_REPO_BRANCH=master \
        -e JHIPSTER_TEST_FRONT=0 \
        -e JHIPSTER_TEST_PACKAGING=0 \
        -t jhipster-tester
}

#-------------------------------------------------------------------------------

cd "$JHIPSTER_TRAVIS"
# runContainerSkipFront app-psql-es-noi18n
# runContainerSkipFront app-mongodb
# runContainerSkipFront app-cassandra
runContainerSkipFrontNoDaemon app-mysql
# runContainer app-gateway
# runContainer app-hazelcast-cucumber
