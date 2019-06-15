#! /usr/bin/env bash

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# "---------------------------------------------------------"
# "-                                                       -"
# "-  Common commands for all scripts                      -"
# "-                                                       -"


set -o errexit
set -o nounset
set -o pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

source "$ROOT/scripts/common.sh"

get_gce_project
BUCKET_NAME="cka-study-$PROJECT"


gsutil ls gs://$BUCKET_NAME
if [[ $? -eq 0 ]]; then
    echo "Bucket $BUCKET_NAME already exists!"
    exit 0
else
    echo "Creating bucket $BUCKET_NAME"
    gsutil mb gs://cka-study-$PROJECT
fi
