#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <input stream>" >&2
  exit 1
fi


INPUT=$1
source /opt/intel/openvino_2022/setupvars.sh

./build.sh 
./build/intel64/Release/object_detection_demo -m models/yolo5s_fp16.xml -i $INPUT  -at yolo -d GPU -labels coco.names -loop -output_resolution 1280x720


