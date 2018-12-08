FROM ubuntu:16.04

# Download the toolkit from : https://software.seek.intel.com/openvino-toolkit
# OpenVINO version
ARG OV_VERSION=p_2018.4.420
ARG TOOLKIT_NAME=l_openvino_toolkit_${OV_VERSION}
COPY ${TOOLKIT_NAME}.tgz /tmp/${TOOLKIT_NAME}.tgz

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \ 
pciutils cpio cmake python3 \
libpng12-dev \
libcairo2-dev \
libpango1.0-dev \
libglib2.0-dev \
libgtk2.0-dev \
libgstreamer1.0-0 \
libswscale-dev \
libavcodec-dev \
libavformat-dev \
gstreamer1.0-plugins-base \ 
lsb-release

# Install the toolkit in command line
RUN cd /tmp && tar -zxf ${TOOLKIT_NAME}.tgz && cd /tmp/${TOOLKIT_NAME} && sed -i 's/ACCEPT_EULA=decline/ACCEPT_EULA=accept/g' silent.cfg && ./install.sh -s silent.cfg && find /opt/intel/computer_vision_sdk/ -type f | xargs sed -i  's/sudo -E //g'; exit 0

# Install the thirdparty dependencies
RUN cd /opt/intel/computer_vision_sdk/install_dependencies && ./install_cv_sdk_dependencies.sh && /bin/bash -c "source /opt/intel/computer_vision_sdk/bin/setupvars.sh"

# Insatall model optimizer
RUN cd /opt/intel/computer_vision_sdk/deployment_tools/model_optimizer/install_prerequisites && sed -i 's/sudo -E //g' * &&  ./install_prerequisites.sh

# Clean the environment
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && cd /tmp/ && rm -rf *

