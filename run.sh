#!/bin/bash

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------
runContainer() {
    local application="$1"
    docker run \
        -d --name $application --label=test \
        -v "/home/pgrimaud/projects/pascalgrimaud/jhipster-tester/travis/docker/$application":/home/jhipster/volume/app:ro \
        -v ~/.m2:/home/jhipster/volume/.m2:ro \
        -v ~/.embedmongo/:/home/jhipster/.embedmongo/:ro \
        -v /home/pgrimaud/projects/pascalgrimaud/jhipster-speedup/node_modules:/home/jhipster/volume/node_modules:ro \
        -t tester
}

runContainerSkipFront() {
    local application="$1"
    docker run \
        -d --name $application --label=test \
        -v "/home/pgrimaud/projects/pascalgrimaud/jhipster-tester/travis/docker/$application":/home/jhipster/volume/app:ro \
        -v ~/.m2:/home/jhipster/volume/.m2:ro \
        -v ~/.embedmongo/:/home/jhipster/.embedmongo/:ro \
        -v /home/pgrimaud/projects/pascalgrimaud/jhipster-speedup/node_modules:/home/jhipster/volume/node_modules:ro \
        -e JHIPSTER_TEST_FRONT=0
        -t tester
}

#-------------------------------------------------------------------------------
# Tests
#-------------------------------------------------------------------------------

# runContainer app-cassandra-gradle
# runContainer app-mongodb-oauth2
# runContainer app-mongodb-social
runContainer ms-gradle

# docker run \
# -d --name app-mysql \
# -v /home/pgrimaud/projects/pascalgrimaud/jhipster-tester/travis/samples/app-mysql:/home/jhipster/volume/app:ro \
# -v ~/.m2:/home/jhipster/volume/.m2:ro \
# -v /home/pgrimaud/projects/pascalgrimaud/jhipster-speedup/node_modules:/home/jhipster/volume/node_modules:ro \
# -t tester
#
# docker run \
# -d --name app-cassandra \
# -v /home/pgrimaud/projects/pascalgrimaud/jhipster-tester/travis/samples/app-cassandra:/home/jhipster/volume/app:ro \
# -v ~/.m2:/home/jhipster/volume/.m2:ro \
# -v /home/pgrimaud/projects/pascalgrimaud/jhipster-speedup/node_modules:/home/jhipster/volume/node_modules:ro \
# -t tester
#
# docker run \
# -d --name app-mongodb \
# -v /home/pgrimaud/projects/pascalgrimaud/jhipster-tester/travis/samples/app-mongodb:/home/jhipster/volume/app:ro \
# -v ~/.m2:/home/jhipster/volume/.m2:ro \
# -v /home/pgrimaud/projects/pascalgrimaud/jhipster-speedup/node_modules:/home/jhipster/volume/node_modules:ro \
# -v ~/.embedmongo/:/home/jhipster/.embedmongo/:ro \
# -t tester
#
# docker run \
# -d --name app-oauth2 --label=test \
# -v /home/pgrimaud/projects/pascalgrimaud/jhipster-tester/travis/samples/app-oauth2:/home/jhipster/volume/app:ro \
# -v ~/.m2:/home/jhipster/volume/.m2:ro \
# -v /home/pgrimaud/projects/pascalgrimaud/jhipster-speedup/node_modules:/home/jhipster/volume/node_modules:ro \
# -t tester
#
# docker run \
# -d --name app-cassandra-gradle --label=test \
# -v /home/pgrimaud/projects/pascalgrimaud/jhipster-tester/travis/docker/app-cassandra-gradle:/home/jhipster/volume/app:ro \
# -v ~/.m2:/home/jhipster/volume/.m2:ro \
# -v /home/pgrimaud/projects/pascalgrimaud/jhipster-speedup/node_modules:/home/jhipster/volume/node_modules:ro \
# -t tester

# docker run \
# -d --name app-psql-es-noi18n \
# -v /home/pgrimaud/workspace/pascalgrimaud/jhipster-tester/samples/app-psql-es-noi18n:/home/jhipster/volume/app:ro \
# -v /home/pgrimaud/.m2:/home/jhipster/volume/.m2:ro \
# -v /home/pgrimaud/workspace/pascalgrimaud/jhipster-tester/node_modules:/home/jhipster/volume/node_modules:ro \
# -v /home/pgrimaud/workspace/pascalgrimaud/jhipster-tester/generator-jhipster:/home/jhipster/volume/generator-jhipster:ro \
# -t tester
#
# docker run \
# -d --name app-gateway \
# -v /home/pgrimaud/workspace/pascalgrimaud/jhipster-tester/samples/app-gateway:/home/jhipster/volume/app:ro \
# -v /home/pgrimaud/.m2:/home/jhipster/volume/.m2:ro \
# -v /home/pgrimaud/workspace/pascalgrimaud/jhipster-tester/node_modules:/home/jhipster/volume/node_modules:ro \
# -v /home/pgrimaud/workspace/pascalgrimaud/jhipster-tester/generator-jhipster:/home/jhipster/volume/generator-jhipster:ro \
# -t tester
#
# docker run \
# -d --name app-gradle \
# -v /home/pgrimaud/workspace/pascalgrimaud/jhipster-tester/samples/app-gradle:/home/jhipster/volume/app:ro \
# -v /home/pgrimaud/.m2:/home/jhipster/volume/.m2:ro \
# -v /home/pgrimaud/workspace/pascalgrimaud/jhipster-tester/node_modules:/home/jhipster/volume/node_modules:ro \
# -v /home/pgrimaud/workspace/pascalgrimaud/jhipster-tester/generator-jhipster:/home/jhipster/volume/generator-jhipster:ro \
# -t tester
#
# docker run \
# -d --name app-hazelcast-cucumber \
# -v /home/pgrimaud/workspace/pascalgrimaud/jhipster-tester/samples/app-hazelcast-cucumber:/home/jhipster/volume/app:ro \
# -v /home/pgrimaud/.m2:/home/jhipster/volume/.m2:ro \
# -v /home/pgrimaud/workspace/pascalgrimaud/jhipster-tester/node_modules:/home/jhipster/volume/node_modules:ro \
# -v /home/pgrimaud/workspace/pascalgrimaud/jhipster-tester/generator-jhipster:/home/jhipster/volume/generator-jhipster:ro \
# -t tester
