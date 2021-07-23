#!/bin/bash
set -e
SOURCE_DIR=${TEST_SOURCE_DIR:-$(dirname $(readlink -f $0))}
BUILD_DIR=${TEST_BUILD_DIR:-$PWD/testenv}
cmake -S ${SOURCE_DIR} -B ${BUILD_DIR}
cmake --build ${BUILD_DIR} --target test
