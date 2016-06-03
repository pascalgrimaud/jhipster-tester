#!/bin/bash

################################################################################
# Variables
################################################################################
VOLUME_APP=/home/jhipster/volume/app
VOLUME_GENERATOR=/home/jhipster/volume/generator-jhipster
VOLUME_M2=/home/jhipster/volume/.m2
VOLUME_GRADLE=/home/jhipster/volume/.gradle
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

log "[Phase-1] prepare the working folder: /home/jhipster/app"
cd /home/jhipster/
rm -rf /home/jhipster/app/*
rm -rf /home/jhipster/app/.*
ls -al /home/jhipster/app/

if [[ (-f "$VOLUME_APP"/mvnw) || (-f "$VOLUME_APP"/gradlew) ]]; then
    existing=1
    log "[Phase-1] mvnw or gradlew found -> existing project"
    log "[Phase-1] copy all files and folders except node_modules -> /home/jhipster/app"
    cd "$VOLUME_APP"
    cp -r `ls -A | grep -v "node_modules"` "/home/jhipster/app/"
else
    existing=0
    log "[Phase-1] .yo-rc.json found -> need to generate project"
    log "[Phase-1] copy .yo-rc.json"
    cp "$VOLUME_APP"/.yo-rc.json /home/jhipster/app/.yo-rc.json
    if [ -d "$VOLUME_APP"/.jhipster ]; then
      log "[Phase-1] copy .jhipster"
        cp -R "$VOLUME_APP"/.jhipster /home/jhipster/app/
    fi
fi
ls -al /home/jhipster/app/
cat /home/jhipster/app/.yo-rc.json
echo " "

################################################################################
# Change generator-jhipster if needed
################################################################################
npm set progress=false
# test URL, test BRANCH
if [ "$existing" == 0 ]; then
    if [ ! -z ${JHIPSTER_REPO_URL+x} ]; then
        if [ ! -z ${JHIPSTER_REPO_BRANCH+x} ]; then
            log "[Phase-2] git clone -b $JHIPSTER_REPO_BRANCH $JHIPSTER_REPO_URL"
            git clone -b $JHIPSTER_REPO_BRANCH $JHIPSTER_REPO_URL /home/jhipster/generator/
        else
            log "[Phase-2] git clone $JHIPSTER_REPO_BRANCH"
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
        version=$(cat /usr/lib/node_modules/generator-jhipster/package.json | grep \"version\": | awk '{print $2}' | sed 's/\"//g;s/,//g')
        log "[Phase-2] Use default generator-jhipster inside container : $version"
    fi
else
    log "[Phase-2] Existing project, no need generator-jhipster"
fi

################################################################################
# cache node_modules, m2, gradle
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

if [ -d "$VOLUME_GRADLE" ]; then
    log "[Phase-3] Volume detected for gradle"
    cp -R "$VOLUME_GRADLE" /home/jhipster/
else
    log "[Phase-3] No cache for gradle"
fi

################################################################################
# start generate project
################################################################################
cd /home/jhipster/app/
if [ "$existing" == 0 ]; then
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
    if [ "$JHIPSTER_TEST_FRONT" == 1 ]; then
        log "[Phase-4] npm install"
        npm install
    fi
fi

################################################################################
# generate existing entities
################################################################################
if [ "$existing" == 0 ]; then
    if [ -d "/home/jhipster/app/.jhipster" ]; then
        log "[Phase-5] generate entities"
        for f in `ls /home/jhipster/app/.jhipster`; do
            yo jhipster:entity ${f%.*} --regenerate --force
        done
    else
        log "[Phase-5] no entities"
    fi
else
    log "[Phase-4] Existing project, skip regeneration entities"
fi

################################################################################
# back-end tests
################################################################################
if [ $JHIPSTER_TEST_BACK == 1 ]; then
    log "[Phase-6] Start back-end tests"
    if [ -f /home/jhipster/app/mvnw ]; then
        ./mvnw test
    elif [ -f /home/jhipster/app/gradlew ]; then
        ./gradlew test
    else
        log "[Phase-6] Error no maven/gradle project"
        exit 6
    fi
    status=$?
    if [ $status -ne 0 ]; then
        log "[Phase-6] Error when launching back-end test"
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
        log "[Phase-7] Error when launching front-end test"
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
    if [ -f /home/jhipster/app/mvnw ]; then
        ./mvnw package -Pprod -DskipTests=true
    elif [ -f /home/jhipster/app/gradlew ]; then
        ./gradlew bootRepackage -Pprod -x test
    else
        log "[Phase-8] Error no maven/gradle project"
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
