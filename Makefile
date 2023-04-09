#----------------------------------------------------------------------------------------------------------------------
# Flags
#----------------------------------------------------------------------------------------------------------------------
SHELL:=/bin/bash
CURRENT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

DOCKER_IMAGE_NAME=object_detection_image
#export DOCKER_BUILDKIT=1

DOCKER_RUN_PARAMS= \
	-it --rm \
	--device /dev/dri \
	-e DISPLAY=${DISPLAY}  -v /tmp/.X11-unix:/tmp/.X11-unix  -v ${HOME}/.Xauthority:/home/root/.Xauthority \
	-v ${CURRENT_DIR}/streams:/workspace/streams \
	${DOCKER_IMAGE_NAME}


#----------------------------------------------------------------------------------------------------------------------
# Targets
#----------------------------------------------------------------------------------------------------------------------
default: object_detection 
.PHONY:  

build:
	@$(call msg, Building Docker image ${DOCKER_IMAGE_NAME} ...)
	@docker build  -t ${DOCKER_IMAGE_NAME} .
	
object_detection: build
	@$(call msg, Starting Object Detection demo   ...)
	@xhost +
	@docker run ${DOCKER_RUN_PARAMS} \
		python3 ./open_model_zoo/demos/object_detection_demo/python/object_detection_demo.py \
			-m ./models/public/yolox-tiny/FP16/yolox-tiny.xml \
			-at yolox \
			--labels ./labels/coco.txt \
			-d GPU \
			--loop \
			-i ./streams/video2.mp4 \

road_segmentation: build
	@$(call msg, Starting Road Segmentation demo   ...)
	@xhost +
	@docker run ${DOCKER_RUN_PARAMS} \
		python3 ./open_model_zoo/demos/segmentation_demo/python/segmentation_demo.py \
		-m ./models/intel/road-segmentation-adas-0001/FP32/road-segmentation-adas-0001.xml \
		-at segmentation \
		-d GPU \
		--loop \
		-i ./streams/road.mp4
	

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

