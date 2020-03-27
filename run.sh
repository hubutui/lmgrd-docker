#!/bin/bash

MY_HOSTNAME=#YOUR HOSTNAME HERE
MY_MAC=#YOUR MAC HERE
MY_LMGRD_PORT=27000
MY_MLM_PORT=27001

# MY_LICENSE_ROOT is where you store license files on the host
MY_LICENSE_ROOT="/etc/lmgrd/licenses"
# MY_LICENSE_FILE is license file you want to use relative to MY_LICENSE_ROOT
MY_LICENSE_FILE="matlab/license.dat"

docker run -it --rm --user nobody --hostname ${MY_HOSTNAME}         \
    --env LMGRD_PORT=${MY_LMGRD_PORT} --env MLM_PORT=${MY_MLM_PORT} \
    -p ${MY_LMGRD_PORT}:${MY_LMGRD_PORT}                            \
    -p ${MY_MLM_PORT}:${MY_MLM_PORT}                                \
    --env LM_LICENSE_FILE="/etc/lmgrd/licenses/${MY_LICENSE_FILE}"  \
    -v ${MY_LICENSE_ROOT}:"/etc/lmgrd/licenses"                     \
    -v "/usr/tmp":"/usr/tmp"                                        \
    --mac-address ${MY_MAC} butui/lmgrd
