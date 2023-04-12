FROM openvino/ubuntu20_dev:latest
ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN apt update -y
RUN apt install -y python3 python3-pip  git python3-opencv  python3-tk 

RUN mkdir /workspace
RUN mkdir /workspace/models

WORKDIR  /workspace/models
RUN omz_downloader --name yolox-tiny && omz_converter --name yolox-tiny
RUN omz_downloader --name ssd_mobilenet_v1_coco && omz_converter --name ssd_mobilenet_v1_coco
RUN omz_downloader --name road-segmentation-adas-0001



WORKDIR  /workspace/
RUN git clone --recurse-submodules https://github.com/openvinotoolkit/open_model_zoo.git
RUN pip3 install -r ./open_model_zoo/demos/common/python/requirements.txt

COPY labels  /workspace/labels
WORKDIR  /workspace

