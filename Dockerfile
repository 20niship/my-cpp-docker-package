# FROM debian:12-slim
FROM ubuntu:24.04

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV DEBIAN_FRONTEND=noninteractive

# RUN add-apt-repository ppa:ubuntu-toolchain-r/ppa -y
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash - 
RUN apt update && \
    apt install -y --no-install-recommends \
    default-jdk npm nodejs git cmake make wget lcov curl libfmt-dev libssl-dev \
    g++-12 gcc-12 \
    mesa-vulkan-drivers libopencv-dev \
    libglu1-mesa-dev libglfw3-dev libglew-dev libglm-dev ninja-build \
    libfreetype-dev libeigen3-dev libassimp-dev libpcl-dev libbullet-dev libopenal-dev \
    python3.12-venv libpython3.12-dev python3.12 \ 
    libalut-dev libogg-dev ffmpeg libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavdevice-dev libffmpeg-nvenc-dev 
    
# install opencascade
RUN apt install -y xfonts-scalable libocct-data-exchange-dev libocct-draw-dev libocct-foundation-dev libocct-modeling-algorithms-dev libocct-modeling-data-dev libocct-ocaf-dev libocct-visualization-dev

ENV CXX=/usr/bin/g++-12 CC=/usr/bin/gcc-12
RUN ln -s /usr/bin/g++-12 /usr/bin/g++

RUN \
  mkdir -p ~/.config/pip 
RUN touch ~/.config/pip/pip.conf &&  \
  echo "[global]" >> ~/.config/pip/pip.conf && \
  echo "break-system-packages = true" >> ~/.config/pip/pip.conf

RUN curl -kL https://bootstrap.pypa.io/get-pip.py | python3.12 -
RUN pip3 install --upgrade pip && \
    pip3 install libclang toml colorlog pyyaml numpy pybind11 && \
    npm install -g yarn

# build curlpp
RUN git clone https://github.com/jpbarrette/curlpp.git && \
    cd curlpp && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON && \
    make -j10 && \
    make install && \
    cd ../.. && \
    rm -rf curlpp


#  build drogon
RUN git clone https://github.com/drogonframework/drogon.git && \
    cd drogon && \
    git submodule update --init && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON && \
    make -j10 && \
    make install && \
    cd ../.. && \
    rm -rf drogon

# build pybind
RUN git clone https://github.com/pybind/pybind11.git && \
    cd pybind11 && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON && \
    make -j10 && \
    make install && \
    cd ../.. && \
    rm -rf pybind11

# build mcut
RUN git clone https://github.com/20niship/mcut.git && \
    cd mcut && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release  && \
    make -j10 && \
    make install && \
    cd ../.. && \
    rm -rf mcut

# build ifcplusplus
RUN git clone https://github.com/20niship/ifcplusplus.git  --depth=1 && \
    cd ifcplusplus && \
    git checkout af7383984ca && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release  && \
    make -j10 && \
    make install && \
    cd ../.. && \
    rm -rf ifcplusplus


# build mujoco
RUN git clone https://github.com/google-deepmind/mujoco.git --depth=1 && \
    cd mujoco && \
    git checkout 3.2.7 && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_MUJOCO_STUDIO=OFF -DBUILD_MUJOCO_EXAMPLES=OFF -DBUILD_MUJOCO_TESTS=OFF && \
    make -j10 && \
    make install && \
    cd ../.. && \
    rm -rf mujoco

ENV LD_LIBRARY_PATH=/usr/local/lib:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

