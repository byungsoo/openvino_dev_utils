# OpenVINO Dev Utils

## Installation with docker
### Download the installation .tgz file from the website

https://software.seek.intel.com/openvino-toolkit

### Install udev rules on the host machine

```
sudo cp 97-usbboot.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo udevadm trigger
sudo ldconfig	
```

### Build the docker image

```
docker build -t ncs2_dev .
```


### Run a container from the image
    
NOTE: Run the command below at your own risk. Some options can harm the host system.
```
docker run -it --privileged --rm -d --net=host -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro -v /dev:/dev --name=ncs2_dev ncs2_dev
```


### Add X11 connection on the host machine
```
xhost +local:`docker inspect --format='{{ .Config.Hostname }}' $(docker ps -l -q)`
```

### Run the demo app
```
docker exec -it ncs2_dev /opt/intel/computer_vision_sdk/deployment_tools/demo/demo_security_barrier_camera.sh -d MYRIAD
```
You should see a success message with a pop-up visualization.
