source /opt/intel/openvino_2022/setupvars.sh

mkdir -p build
cd build && \
	cmake ../../../open_model_zoo/demos/ -B . && \
	make -j`nproc`  object_detection_demo
