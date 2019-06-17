#! /usr/bin/env bash
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
# "-  Creates cluster and deploys demo application         -"
# "-                                                       -"
# "---------------------------------------------------------"
set -o errexit
set -o nounset
set -o pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# shellcheck source=scripts/common.sh
source "$ROOT/scripts/common.sh"

PROJECT=$(gcloud config get-value project)
CONTEXT=$(kubectl config view --minify -o=jsonpath='{.contexts[0].context.cluster}')

## Enabling docker gcp helper
gcloud auth configure-docker

MODULE=$1

echo "Executing Module: ${MODULE} on cluster ${CONTEXT}"

# Use Bazel to compile, build, and deploy the Java Spring Boot API
CMD=(bazel run
  "--incompatible_disallow_dict_plus=false"
  --define CLUSTER="${CONTEXT}"
  //modules/${MODULE}:dev.apply)

"${CMD[@]}"