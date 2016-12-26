#!/bin/bash

if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo -e "Usage: $0 [OPTION]...
Options:
 [-d|--destination /opt/buildroot]\tsource package destination directory
 [-c|--copy-artifacts false]\tcopy artifacts to source package directory, default true
 [-b|--build false]\tbuild package from source, default true
 [-h|--help]"
    exit 0
fi

SOURCE_PATH="/opt/buildroot"
BUILD="true"
COPY="true"
# Parse command line arguments
while [[ $# -ge 1 ]]; do
    key="$1"
    case $key in
        -d|--destination)
        SOURCE_PATH="$2"
        shift
        ;;
        -c|--copy-artifacts)
        COPY="$2"
        shift
        ;;
        -b|--build)
        BUILD="$2"
        shift
        ;;
        *)
            # unknown option
        ;;
    esac
    shift
done

cd $SOURCE_PATH/*
if [ $BUILD == "true" ]; then
    echo "** Installing build dependencies"
    mk-build-deps -i -t "apt-get -y --no-install-recommends"
    dpkg -i *.deb
    apt-get update
    apt-get -f -y install
    rm *.deb
    echo "** Building package"
    dpkg-buildpackage -us -uc -F
fi
if [ $COPY == "true" ]; then
    echo "** Copying result files into $SOURCE_PATH"
    cp ../*.d{eb,sc} .
    cp ../*z .
    cp ../*.changes .
fi
