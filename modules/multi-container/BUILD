# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load("@k8s_deploy//:defaults.bzl", "k8s_deploy")
load("@k8s_service//:defaults.bzl", "k8s_service")
load("@io_bazel_rules_k8s//k8s:objects.bzl", "k8s_objects")
load("@io_bazel_rules_k8s//k8s:object.bzl", "k8s_object")


package(default_visibility = ["//visibility:public"])

licenses(["notice"])  # Apache 2.0

k8s_object(
    name = "ns",
    kind = "namespace",
    template = "namespace.yaml",
    cluster = "$(CLUSTER)"
)

k8s_object(
    name = "redis",
    kind = "pod",
    template = "data-tier.yaml",
    cluster = "$(CLUSTER)"
)

k8s_object(
    name = "server",
    kind = "pod",
    template = "app-tier.yaml",
    cluster = "$(CLUSTER)"
)

k8s_objects(
   name = "dev",
   objects = [
      ":ns",
      ":redis",
      ":server"
   ]
)
