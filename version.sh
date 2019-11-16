#!/bin/bash

function get_git_current_branch() {
    git branch 2>/dev/null | sed -n '/\* /s///p' 2>/dev/null
}

function branch_to_version() {
    if test "${1}" = "master"; then
       echo "latest"
    else
        TMP_VERSION=`echo ${1} |awk -F '.' '{print $1;}'`
        N=`echo ${TMP_VERSION} |grep '^[0-9][0-9]*$' |wc -l`
        if test ${N} -gt 0; then
            echo "V${TMP_VERSION}"
        else
            echo "dev"
        fi
    fi
}

GIT_BRANCH=`get_git_current_branch`
VERSION=`branch_to_version ${GIT_BRANCH}`
echo ${VERSION}
