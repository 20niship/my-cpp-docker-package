FROM alpine:latest

# setup timezone 
# https://wiki.alpinelinux.org/wiki/Setting_the_timezone
RUN apk --update add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata

RUN apk --no-cache add \
     python3 curl cmake ninja-build clang python3-dev py3-pip \
     libxcursor-dev libxi-dev libxinerama-dev libxrandr-dev \
     opencv-dev libx11-dev glfw glfw-dev glew-dev glm-dev freetype-dev \
     zlib-dev curl-dev libcurl 
RUN apk --no-cache add \
     jsoncpp-dev 
RUN apk --no-cache add \
     libressl-dev 
RUN apk --no-cache add \
     eigen assimp-dev pcl lua5.4-dev fmt-dev jsoncpp-dev openssl zlib-dev 
RUN apk --no-cache add \
     pcl-dev boost-dev vtk vtk-dev eigen-dev mesa-dev mesa-gl 
RUN apk --no-cache add \
     --repository=https://dl-cdn.alpinelinux.org/alpine/edge/testing

RUN pip3 install --upgrade pip && \
    pip3 install libclang toml colorlog libclang pyyaml open3d numpy

