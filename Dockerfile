FROM debian:12-slim

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install -y --no-install-recommends \
    default-jdk python3-pip npm nodejs git cmake make wget lcov curl libfmt-dev libssl-dev
RUN apt install -y --no-install-recommends \
    mesa-vulkan-drivers libopencv-dev \
    libglu1-mesa-dev libglfw3-dev libglew-dev libglm-dev \
    libfreetype-dev libeigen3-dev libassimp-dev libpcl-dev liblua5.4-dev 

RUN \
  mkdir -p ~/.config/pip 
RUN touch ~/.config/pip/pip.conf &&  \
  echo "[global]" >> ~/.config/pip/pip.conf && \
  echo "break-system-packages = true" >> ~/.config/pip/pip.conf

RUN pip3 install --upgrade pip && \
    pip3 install libclang toml colorlog pyyaml numpy pybind11 && \
    npm install -g yarn
