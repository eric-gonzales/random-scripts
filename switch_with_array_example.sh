#!/bin/bash

SETUP_ENV_ARGS="add_env_setup_files:add_another_service"

set -f # avoid globbing (expansion of *).
setup_array=(${SETUP_ENV_ARGS//:/ })

for arg in ${setup_array[@]}; do
    case $arg in
      "add_env_setup_files") echo "add env setup files"
        ;;
      "add_another_service") echo "add service"
        ;;
      "upgrade") echo "upgrade"
        ;;
      * ) echo "Could not find arg: ${arg} in setup_array"
        ;;
    esac
done
