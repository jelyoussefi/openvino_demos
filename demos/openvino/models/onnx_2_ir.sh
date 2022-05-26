mo --input_model ./yolov5s.onnx --model_name yolo5s_fp16 -s 255  --reverse_input_channels --output Conv_198,Conv_217,Conv_236 --data_type FP16
mo --input_model ./yolov5s.onnx --model_name yolo5s_fp32 -s 255  --reverse_input_channels --output Conv_198,Conv_217,Conv_236 --data_type FP32
