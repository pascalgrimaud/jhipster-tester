#!/bin/bash

################################################################################
# Variables
################################################################################
VOLUME_APP=/home/jhipster/volume/app
VOLUME_GENERATOR=/home/jhipster/volume/generator-jhipster
VOLUME_M2=/home/jhipster/volume/.m2
VOLUME_NODE_MODULES=/home/jhipster/volume/node_modules

################################################################################
# Functions
################################################################################
function log {
    echo "[$(date)] $*"
}

################################################################################
# Detect a .yo-rc.json to start tester
################################################################################
if [ ! -f "$VOLUME_APP"/.yo-rc.json ]; then
    log "[Phase-1] No .yo-rc.json file -> stop tester"
    exit 0
fi
log "[Phase-1] .yo-rc.json found!"
cp "$VOLUME_APP"/.yo-rc.json /home/jhipster/app/.yo-rc.json

################################################################################
# Change generator-jhipster if needed
################################################################################
npm set progress=false
# test URL, test BRANCH
log "[Phase-2] test URL, test BRANCH"
if [ ! -z ${JHIPSTER_REPO_URL+x} ]; then
    log "[Phase-2] need to git clone"
    if [ ! -z ${JHIPSTER_REPO_BRANCH+x} ]; then
        log "[Phase-2] let's clone the branch $JHIPSTER_REPO_BRANCH of $JHIPSTER_REPO_URL"
        git clone -b $JHIPSTER_REPO_BRANCH $JHIPSTER_REPO_URL /home/jhipster/generator/
    else
        log "[Phase-2] let's clone the master of $JHIPSTER_REPO_BRANCH"
        git clone $JHIPSTER_REPO_URL /home/jhipster/generator/
    fi
    cd /home/jhipster/generator/
    log "[Phase-2] npm install"
    npm install
    log "[Phase-2] npm link"
    npm link
elif [ -f "$VOLUME_GENERATOR"/package.json ]; then
    log "[Phase-2] Volume detected for generator-jhipster: /home/jhipster/generator/"
    cp -R "$VOLUME_GENERATOR" /home/jhipster/generator/
    cd /home/jhipster/generator/
    log "[Phase-2] npm install"
    npm install
    log "[Phase-2] npm link"
    npm link
else
    log "[Phase-2] Use default generator-jhipster inside container"
fi

################################################################################
# cache node_modules and m2
################################################################################
if [ -d "$VOLUME_NODE_MODULES" ]; then
    log "[Phase-3] Volume detected for node_modules"
    cp -R "$VOLUME_NODE_MODULES" /home/jhipster/app/
else
    log "[Phase-3] No cache for node_modules"
fi

if [ -d "$VOLUME_M2" ]; then
    log "[Phase-3] Volume detected for m2"
    cp -R "$VOLUME_M2" /home/jhipster/
else
    log "[Phase-3] No cache for m2"
fi

################################################################################
# start generate project
################################################################################
cd /home/jhipster/app/
if [ -f mvnw ]; then
    BUILDTOOL="maven"
elif [ -f gradlew ]; then
    BUILDTOOL="gradle"
fi

if [ -z ${BUILDTOOL+x} ]; then
    log "[Phase-4] Start generate project"
    cd /home/jhipster/app/
    log "[Phase-4] npm link generator-jhipster"
    npm link generator-jhipster
    if [ $JHIPSTER_TEST_FRONT == 1 ]; then
        log "[Phase-4] yo jhipster --force --no-insight"
        yo jhipster --force --no-insight
    else
        log "[Phase-4] yo jhipster --force --no-insight --skip-install"
        yo jhipster --force --no-insight --skip-install
    fi
else
    log "[Phase-4] Existing project, skip regeneration"
fi

if [ -f mvnw ]; then
    BUILDTOOL="maven"
elif [ -f gradlew ]; then
    BUILDTOOL="gradle"
fi

################################################################################
# generate existing entities
################################################################################
if [ -d "/home/jhipster/app/.jhipster" ]; then
    log "[Phase-5] generate entities"
    for f in `ls /home/jhipster/app/.jhipster`; do
        yo jhipster:entity ${f%.*} --regenerate --force
    done
else
    log "[Phase-5] no entities"
fi

################################################################################
# back-end tests
################################################################################
if [ $JHIPSTER_TEST_BACK == 1 ]; then
    log "[Phase-6] Start back-end tests"
    if [ "$BUILDTOOL" == "maven" ]; then
        ./mvnw test
    elif [ "$BUILDTOOL" == "gradle" ]; then
        ./gradlew test
    else
        log "Error no maven/gradle project"
        exit 6
    fi
    status=$?
    if [ $status -ne 0 ]; then
        log "Error when launching back-end test"
        exit 6
    fi
else
    log "[Phase-6] Skip back-end tests"
fi

################################################################################
# front-end tests
################################################################################
if [ $JHIPSTER_TEST_FRONT == 1 ] && [ -f "gulpfile.js" ]; then
    log "[Phase-7] Start front-end tests"
    gulp test --no-notification
    status=$?
    if [ $status -ne 0 ]; then
        log "Error when launching front-end test"
        exit 7
    fi
else
    log "[Phase-7] Skip front-end tests"
fi

################################################################################
# packaging
################################################################################
if [ $JHIPSTER_TEST_PACKAGING == 1 ]; then
    log "[Phase-8] Start packaging"
    if [ "$BUILDTOOL" == "maven" ]; then
        ./mvnw package -Pprod -DskipTests=true
    elif [ "$BUILDTOOL" == "gradle" ]; then
        ./gradlew bootRepackage -Pprod -x test
    else
        exit 8
    fi
    status=$?
    if [ $status -ne 0 ]; then
        log "[Phase-8] Error when packaging"
        exit 8
    fi
else
    log "[Phase-8] Skip packaging"
fi
################################################################################

log "End of tests"
exit 0
