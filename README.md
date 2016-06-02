# JHipster tester

[![Build Status][travis-image]][travis-url]

Travis build for pull requests: [jhipster-tester/pull_requests](https://travis-ci.org/pascalgrimaud/jhipster-tester/pull_requests)

## Introduction

This project is used to test a JHipster project with Docker

## How to use

### Installation

First, clone this project:

```
git clone https://github.com/pascalgrimaud/jhipster-tester.git
cd jhipster-tester
```

Build the Docker image with script shell:

```
./build.sh
```

Or you can directly build with Docker command:

```
docker build -t jhipster-tester -f docker/Dockerfile docker/
```

### Quick test

Here the default docker-compose.yml file:

```yaml
version: '2'
services:
    jhipster-tester:
        image: jhipster-tester
        volumes:
            ####################################################################
            # the most important is here : mount the volume with .yo-rc.json   #
            ####################################################################
            - ./samples/app:/home/jhipster/volume/app:ro
            ####################################################################
            - ~/.m2:/home/jhipster/volume/.m2:ro
            - ~/.gradle:/home/jhipster/volume/.gradle:ro
            - ~/.embedmongo/:/home/jhipster/.embedmongo/:ro
            # to speedup the front-end build, you can mount a volume with node_modules node4, npm3
            #- ~/projects/jhipster-speedup/node_modules:/home/jhipster/volume/node_modules:ro
        environment:
            # - JHIPSTER_REPO_URL=https://github.com/jhipster/generator-jhipster.git
            # - JHIPSTER_REPO_BRANCH=master
            - JHIPSTER_TEST_BACK=1
            - JHIPSTER_TEST_FRONT=1
            - JHIPSTER_TEST_PACKAGING=1

```

Launch the default docker-compose.yml file:

```
docker-compose up
```

It will test the **samples/app/.yo-rc.json** project, with the default generator-jhipster
inside the Docker image. The entities inside .jhipster/ folder will be generated too.

### Test another configuration

You can simply edit the **samples/app/.yo-rc.json**

Or, you can change the volume in the **docker-compose.yml**
For example, to test a cassandra project:

```yaml
version: '2'
services:
    jhipster-tester:
        image: jhipster-tester
        volumes:
            ####################################################################
            # the most important is here : mount the volume with .yo-rc.json   #
            ####################################################################
            - ./samples/app-cassandra:/home/jhipster/volume/app:ro
            ####################################################################
            - ~/.m2:/home/jhipster/volume/.m2:ro
            - ~/.gradle:/home/jhipster/volume/.gradle:ro
            - ~/.embedmongo/:/home/jhipster/.embedmongo/:ro
            # to speedup the front-end build, you can mount a volume with node_modules node4, npm3
            #- ~/projects/jhipster-speedup/node_modules:/home/jhipster/volume/node_modules:ro
        environment:
            # - JHIPSTER_REPO_URL=https://github.com/jhipster/generator-jhipster.git
            # - JHIPSTER_REPO_BRANCH=master
            - JHIPSTER_TEST_BACK=1
            - JHIPSTER_TEST_FRONT=1
            - JHIPSTER_TEST_PACKAGING=1
```

### Test the latest version of JHipster

Edit the docker-compose.yml file, by putting the information to
**JHIPSTER_REPO_URL** and **JHIPSTER_REPO_BRANCH**:

```yaml
version: '2'
services:
    jhipster-tester:
        image: jhipster-tester
        volumes:
            ####################################################################
            # the most important is here : mount the volume with .yo-rc.json   #
            ####################################################################
            - ./samples/app:/home/jhipster/volume/app:ro
            ####################################################################
            - ~/.m2:/home/jhipster/volume/.m2:ro
            - ~/.gradle:/home/jhipster/volume/.gradle:ro
            - ~/.embedmongo/:/home/jhipster/.embedmongo/:ro
            # to speedup the front-end build, you can mount a volume with node_modules node4, npm3
            #- ~/projects/jhipster-speedup/node_modules:/home/jhipster/volume/node_modules:ro
        environment:
            - JHIPSTER_REPO_URL=https://github.com/jhipster/generator-jhipster.git
            - JHIPSTER_REPO_BRANCH=master
            - JHIPSTER_TEST_BACK=1
            - JHIPSTER_TEST_FRONT=1
            - JHIPSTER_TEST_PACKAGING=1
```

### Skip front and packaging

Edit the docker-compose.yml file, by putting the 0 to
**JHIPSTER_TEST_FRONT** and **JHIPSTER_TEST_PACKAGING** :

```yaml
version: '2'
services:
    jhipster-tester:
        image: jhipster-tester
        volumes:
            ####################################################################
            # the most important is here : mount the volume with .yo-rc.json   #
            ####################################################################
            - ./samples/app:/home/jhipster/volume/app:ro
            ####################################################################
            - ~/.m2:/home/jhipster/volume/.m2:ro
            - ~/.gradle:/home/jhipster/volume/.gradle:ro
            - ~/.embedmongo/:/home/jhipster/.embedmongo/:ro
            # to speedup the front-end build, you can mount a volume with node_modules node4, npm3
            #- ~/projects/jhipster-speedup/node_modules:/home/jhipster/volume/node_modules:ro
        environment:
            # - JHIPSTER_REPO_URL=https://github.com/jhipster/generator-jhipster.git
            # - JHIPSTER_REPO_BRANCH=master
            - JHIPSTER_TEST_BACK=1
            - JHIPSTER_TEST_FRONT=0
            - JHIPSTER_TEST_PACKAGING=0
```

## Use Travis

You have to:
- change: samples/app/.yo-rc.json
- edit or remove: samples/app/.jhipster/

Then you can pull request and see [jhipster-tester/pull_requests](https://travis-ci.org/pascalgrimaud/jhipster-tester/pull_requests)

[travis-image]: https://travis-ci.org/pascalgrimaud/jhipster-tester.svg?branch=master
[travis-url]: https://travis-ci.org/pascalgrimaud/jhipster-tester
