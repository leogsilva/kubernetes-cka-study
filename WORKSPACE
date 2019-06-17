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

# The WORKSPACE file tells Bazel that this directory is a "workspace", which is like a project root.
# The content of this file specifies all the external dependencies Bazel needs to perform a build.

# IMPORTANT: Read DEVELOPER.md and README.md for more context.

################################################################################
# ESModule imports (and TypeScript imports) can be absolute starting with the workspace name.
# The name of the workspace should match the npm package where we publish, so that these
# imports also make sense when referencing the published package.
# The workspace name also maps to your local filesystem when using Bazel.
# So if you run Bazel, change your workspace name, and run again,
# none of your previously cached outputs will be available.
################################################################################
workspace(name = "kubernetes_cka_study")

################################################################################
# Fetch dependencies for project & Angular client
################################################################################

# "http_archive" is a Bazel rule that loads Bazel repositories &
# makes its targets available for execution.
# It is deprecated however, so we need to manually load it to use it.
# See https://docs.bazel.build/versions/master/be/workspace.html#http_archive
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Load go rules to build kubectl
http_archive(
  name = "io_bazel_rules_go",
  urls = ["https://github.com/bazelbuild/rules_go/releases/download/0.18.5/rules_go-0.18.5.tar.gz"],
  sha256 = "a82a352bffae6bee4e95f68a8d80a70e87f42c4741e6a448bec11998fcc82329",
)
load("@io_bazel_rules_go//go:deps.bzl", "go_rules_dependencies", "go_register_toolchains")

go_rules_dependencies()
go_register_toolchains()

# This is a specific Bazel toolchain needed for RBE Alpha support.
# See DEVELOPER.md for information on RBE.

http_archive(
  name = "bazel_toolchains",
  urls = [
    "https://github.com/bazelbuild/bazel-toolchains/archive/92dd8a7.tar.gz"
  ],
  strip_prefix = "bazel-toolchains-92dd8a7",
  sha256 = "3a6ffe6dd91ee975f5d5bc5c50b34f58e3881dfac59a7b7aba3323bd8f8571a8",
)

load("@bazel_toolchains//rules:rbe_repo.bzl", "rbe_autoconfig")
rbe_autoconfig(name = "rbe_default")


# Skylib provides functions for writing custom Bazel rules.
# We use custom bazel rules in this demo, so we need skylib.
# See https://github.com/bazelbuild/bazel-skylib
# TODO - we need to update this, but scala rules may not be happy
http_archive(
    name = "bazel_skylib",
    sha256 = "2ea8a5ed2b448baf4a6855d3ce049c4c452a6470b1efd1504fdb7c1c134d220a",
    strip_prefix = "bazel-skylib-0.8.0",
    urls = ["https://github.com/bazelbuild/bazel-skylib/archive/0.8.0.tar.gz"],
    )

# The Bazel buildtools repo contains tools like the BUILD file formatter, buildifier
# This commit matches the version of buildifier in angular/ngcontainer
BAZEL_BUILDTOOLS_VERSION = "db073457c5a56d810e46efc18bb93a4fd7aa7b5e"

# This repo contains developer tools for Bazel.
# See https://github.com/bazelbuild/buildtools
http_archive(
    name = "com_github_bazelbuild_buildtools",
    url = "https://github.com/bazelbuild/buildtools/archive/%s.zip" % BAZEL_BUILDTOOLS_VERSION,
    strip_prefix = "buildtools-%s" % BAZEL_BUILDTOOLS_VERSION,
    )



################################################################################
# Kubernetes dependencies
################################################################################

# Load Bazel rule to pull in git repos, rather than http_archives
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

# Download the NodeJS Bazel build rules from GitHub
# Fetch rules_nodejs so we can install our npm dependencies
http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "1db950bbd27fb2581866e307c0130983471d4c3cd49c46063a2503ca7b6770a4",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/0.29.0/rules_nodejs-0.29.0.tar.gz"],
)

# Docker rules for Bazel, needed to containerize our applications
# See https://github.com/bazelbuild/rules_docker
# Download the rules_docker repository at release v0.7.0
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "aed1c249d4ec8f703edddf35cbe9dfaca0b5f5ea6e4cd9e83e99f3b0d1136c3d",
    strip_prefix = "rules_docker-0.7.0",
    urls = ["https://github.com/bazelbuild/rules_docker/archive/v0.7.0.tar.gz"],
)

# Instantiate the "repositories" Bazel rule in rules_docker as "container_repositories"
load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

# Download dependencies for container rules
# See https://github.com/bazelbuild/rules_docker/blob/master/container/container.bzl#L79
container_repositories()

# This requires rules_docker to be fully instantiated before
# it is pulled in.
git_repository(
    name = "io_bazel_rules_k8s",
    commit = "ec7f9ac0e5463bf61885ae97b39c3c901b3a45da",
    remote = "https://github.com/bazelbuild/rules_k8s.git",
)

# Load a couple rules we need from the K8s Bazel repo
load("@io_bazel_rules_k8s//k8s:k8s.bzl", "k8s_repositories", "k8s_defaults")

k8s_repositories()

# Download the dependencies the K8s Bazel rules need
# See https://github.com/bazelbuild/rules_k8s/blob/master/k8s/k8s.bzl#L22
k8s_repositories()

# Set up some default attributes when the K8s rule "k8s_object" is called later
# This only applies to "k8s_object" called with kind = "deployment"
# This also exposes a Bazel rule called "k8s_deploy"
# See https://github.com/bazelbuild/rules_k8s#k8s_defaults

k8s_defaults(
    name = "k8s_deploy",
    kind = "deployment",
    namespace = "default"
)



# Set up some default attributes when the K8s rule "k8s_object" is called later
# This only applies to "k8s_object" called with kind = "service"
# See https://github.com/bazelbuild/rules_k8s#k8s_defaults
k8s_defaults(
    name = "k8s_service",
    kind = "service",
    namespace = "default",
    )

