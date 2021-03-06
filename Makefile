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

# Make will use bash instead of sh
SHELL := /usr/bin/env bash

MODULES	:= helloworld pods-and-services multi-container deployment probes-and-init volumes secrets-and-configmaps

.PHONY: help
help:
	@echo 'Usage'
	@echo '	make terraform 	Run terraform and create cluster'
	@echo '	make bucket 	Create bucket for terraform state'
	@echo '	make deploy 	Deploy a module. List of supported modules: $(MODULES)' 
	@echo ' make destroy    Destroy a module. List of supported modules: $(MODULES)'
#all
.PHONY: all
all: terraform
	@echo "Done"

.PHONY: terraform
terraform:
	@source scripts/terraform.sh

.PHONY: bucket
bucket:
	@source scripts/bucket.sh

.PHONY: teardown
teardown:
	@source scripts/teardown.sh

.PHONY: deploy
deploy:
	@source scripts/create.sh $(MODULE)


.PHONY: destroy
destroy:
	@source scripts/destroy.sh $(MODULE)
