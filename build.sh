#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

if [[ -n "${DEBUG_SCRIPT:-}" ]]; then
    set -o xtrace
    export PS4='+ ${BASH_SOURCE:-}:${FUNCNAME[0]:-}:L${LINENO:-}:   '
    export
fi

readonly ARTIFACTS=( secpro_romfw secpro_ramfw mpro_ram )
readonly ZEPHYR_SDK_INSTALL_DIR=${ZEPHYR_SDK_INSTALL_DIR:-"/opt/toolchains/zephyr-sdk-0.12.2"}
readonly ZEPHYR_TOOLCHAIN_VARIANT=${ZEPHYR_TOOLCHAIN_VARIANT:-zephyr}

PROJECT_REPO=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly OUTPUT_DIR="${PROJECT_REPO}/output"
TOP_DIR=$(dirname "$PROJECT_REPO")
DEBUG_ENABLED="0"

_die() {
    msg="$*"
    echo "ERROR: $msg" >&2 && exit 1
}

_array_contains() {
    local seeking=$1; shift
    local in=1

    for element; do
        if [[ ${element} == "${seeking}" ]]; then
            in=0
            break
        fi
    done
    return $in
}

cmd_clean()
{
    pushd "$PROJECT_REPO" > /dev/null

    echo "clean:"
    rm -rf "${OUTPUT_DIR}"
    echo "done"

    popd > /dev/null
}

build_project()
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

    west build \
        -d "${BUILD_MODE_OUTPUT}/hello_world" -- \
        ${cmake_options} .

    popd > /dev/null
}

if [ $# == 0 ]; then
    _die "Command missing"
fi

# parse cmdline options
while [ $# -gt 0 ]; do
    case "$1" in
        build)        { build_project ; exit 0;      } ;;
        clean)        { cmd_clean; exit 0;      } ;;
        -d) { DEBUG_ENABLED="1";                } ;;
        -*|*)
            cmd_help
            _die "Unknown argument"
            ;;
    esac
    shift
done
