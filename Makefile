#----------------------------------------------------------------------------------------------------------------------
# Flags
#----------------------------------------------------------------------------------------------------------------------
SHELL:=/bin/bash

CURRENT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
OPENVINO_ROOT ?= /opt/intel/openvino_2022


#----------------------------------------------------------------------------------------------------------------------
# Targets
#----------------------------------------------------------------------------------------------------------------------
.PHONY: model_server open_model_zoo

openvino:
	@if [ ! -f "${OPENVINO_ROOT}/setvars.sh" ]; then \
		$(call msg,Installing OpenVINO ...) && \
		wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB && \
		sudo apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB && \
		echo "deb https://apt.repos.intel.com/openvino/2022 focal main" | sudo tee /etc/apt/sources.list.d/intel-openvino-2022.list && \
		sudo apt update && \
		sudo apt install openvino && \
		cd ${OPENVINO_ROOT}/install_dependencies && \
			sudo -E ./install_openvino_dependencies.sh && \
			sudo -E ./install_NEO_OCL_driver.sh; \
	fi
	
model_server:
	@if [ ! -f "${CURRENT_DIR}/model_server/.done" ]; then \
		$(call msg,Installing the OpenVINO Model Server ...) && \
		rm -rf ${CURRENT_DIR}/model_server && \
		git clone https://github.com/openvinotoolkit/model_server && \
		touch ${CURRENT_DIR}/model_server/.done; \
	fi
	
open_model_zoo:
	@if [ ! -f "${CURRENT_DIR}/open_model_zoo/.done" ]; then \
		$(call msg,Installing the Open Model Zoo ...) && \
		rm -rf ${CURRENT_DIR}/open_model_zoo && \
		git clone https://github.com/openvinotoolkit/open_model_zoo.git && \
		cd open_model_zoo && \
		git submodule update --init --recursive && \
		touch ${CURRENT_DIR}/open_model_zoo/.done; \
	fi
		


#----------------------------------------------------------------------------------------------------------------------
# helper functions
#----------------------------------------------------------------------------------------------------------------------
define msg
	tput setaf 2 && \
	for i in $(shell seq 1 120 ); do echo -n "-"; done; echo  "" && \
	echo "         "$1 && \
	for i in $(shell seq 1 120 ); do echo -n "-"; done; echo "" && \
	tput sgr0
endef

