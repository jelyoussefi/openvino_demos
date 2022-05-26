pip3 freeze | grep tensorflow-serving-api > /dev/null || pip3 install tensorflow-serving-api

docker stop person_detection > /dev/null
docker rm person_detection > /dev/null

echo "------------------------------------------------"
echo -e "\tStarting the ovms model server"
echo "------------------------------------------------"
docker run --rm -d \
	--name person_detection  \
	-v `pwd`/model:/models -p 9001:9001 \
	--device=/dev/dri \
	--group-add=$(stat -c "%g" /dev/dri/render* | head -n 1) \
	-u $(id -u):$(id -g) \
	openvino/model_server:latest-gpu \
		--model_path /models \
		--model_name person-vehicle-detection \
		--port 9001  \
		--target_device GPU 

echo "------------------------------------------------"
echo -e "\tStarting the application"
echo "------------------------------------------------"
sleep 3
source /opt/intel/openvino_2022/setupvars.sh && \
python3 person_vehicle_bike_detection.py -n person-vehicle-detection -l data -o detection_out -d 1024 -c 0 -f streams/How_People_Walk.mp4 -i localhost -p 9001
