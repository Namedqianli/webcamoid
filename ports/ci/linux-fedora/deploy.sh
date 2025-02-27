#!/bin/bash

# Webcamoid, webcam capture application.
# Copyright (C) 2017  Gonzalo Exequiel Pedone
#
# Webcamoid is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Webcamoid is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Webcamoid. If not, see <http://www.gnu.org/licenses/>.
#
# Web-Site: http://webcamoid.github.io/

if [ ! -z "${GITHUB_SHA}" ]; then
    export GIT_COMMIT_HASH="${GITHUB_SHA}"
elif [ ! -z "${APPVEYOR_REPO_COMMIT}" ]; then
    export GIT_COMMIT_HASH="${APPVEYOR_REPO_COMMIT}"
elif [ ! -z "${CIRRUS_CHANGE_IN_REPO}" ]; then
    export GIT_COMMIT_HASH="${CIRRUS_CHANGE_IN_REPO}"
fi

export GIT_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

if [ -z "${GIT_BRANCH_NAME}" ]; then
    if [ ! -z "${GITHUB_REF_NAME}" ]; then
        export GIT_BRANCH_NAME="${GITHUB_REF_NAME}"
    elif [ ! -z "${APPVEYOR_REPO_BRANCH}" ]; then
        export GIT_BRANCH_NAME="${APPVEYOR_REPO_BRANCH}"
    elif [ ! -z "${CIRRUS_BRANCH}" ]; then
        export GIT_BRANCH_NAME="${CIRRUS_BRANCH}"
    else
        export GIT_BRANCH_NAME=master
    fi
fi

git clone https://github.com/webcamoid/DeployTools.git

export PATH="${PWD}/.local/bin:${PATH}"
export INSTALL_PREFIX=${PWD}/webcamoid-data-${COMPILER}
export PACKAGES_DIR=${PWD}/webcamoid-packages/linux-${COMPILER}
export BUILD_PATH=${PWD}/build-${COMPILER}
export PYTHONPATH="${PWD}/DeployTools"

xvfb-run --auto-servernum python3 DeployTools/deploy.py \
    -d "${INSTALL_PREFIX}" \
    -c "${BUILD_PATH}/package_info.conf" \
    -o "${PACKAGES_DIR}"
