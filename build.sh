#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

if [[ -n "${DEBUG_SCRIPT:-}" ]]; then
    set -o xtrace
    export PS4='+ ${BASH_SOURCE:-}:${FUNCNAME[0]:-}:L${LINENO:-}:   '
    export
fi

readonly ZEPHYR_SDK_INSTALL_DIR=${ZEPHYR_SDK_INSTALL_DIR:-"/opt/toolchains/zephyr-sdk-0.12.2"}
readonly ZEPHYR_TOOLCHAIN_VARIANT=${ZEPHYR_TOOLCHAIN_VARIANT:-zephyr}

PROJECT_REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly OUTPUT_DIR="${PROJECT_REPO}/output"
TOP_DIR=$(dirname "$PROJECT_REPO")
DEBUG_ENABLED="0"

project_clean()
{
    pushd "$PROJECT_REPO" > /dev/null

    echo "clean:"
    rm -rf "${OUTPUT_DIR}"
    echo "done"

    popd > /dev/null
}

project_build()
{

    export ZEPHYR_TOOLCHAIN_VARIANT
    export ZEPHYR_SDK_INSTALL_DIR

    echo "build:"

    local BUILD_MODE_OUTPUT=

    if [[ "${DEBUG_ENABLED}" -eq 1 ]]; then
        BUILD_MODE_OUTPUT="${OUTPUT_DIR}/debug"
    else
        BUILD_MODE_OUTPUT="${OUTPUT_DIR}/release"
    fi

    local cmake_options="-DPRODUCT_MODULE_ROOT=${PROJECT_REPO}"

    if [[ "${DEBUG_ENABLED}" -eq 1 ]]; then
        cmake_options="-DEXTRA_CFLAGS=\"-gdwarf-2\" -DCONFIG_DEBUG=y -DCONFIG_DEBUG_OPTIMIZATIONS=y ${cmake_options}"
    fi

    pushd "$PROJECT_REPO/applications/hello_world" > /dev/null

    west build -t menuconfig \
        -d "${BUILD_MODE_OUTPUT}/hello_world" -- \
        ${cmake_options} .

    popd > /dev/null
}

project_clean
project_build
