# Start from the L4T base image
FROM nvcr.io/nvidia/l4t-base:r32.4.4

ENV DEBIAN_FRONTEND=noninteractive 

# Install essential build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libopencv-dev \
    ca-certificates \
    curl \
    unzip \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Update to gcc 9
# Add the repository containing GCC 9
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get update && \
    apt-get install -y gcc-9 g++-9 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9 && \
    update-alternatives --config gcc && \
    gcc --version

# we must update cmake for lib Torch
RUN wget https://github.com/Kitware/CMake/releases/download/v3.18.0/cmake-3.18.0-Linux-x86_64.sh \
    && mkdir -p /usr/local/cmake_install \
    && chmod +x cmake-3.18.0-Linux-x86_64.sh \
    && ./cmake-3.18.0-Linux-x86_64.sh --skip-license --prefix=/usr/local/cmake_install/ \
    && rm cmake-3.18.0-Linux-x86_64.sh

# Download and extract LibTorch (PyTorch C++ API) for Jetson
# Make sure to choose the correct version for your CUDA and compute capability
RUN curl -L https://download.pytorch.org/libtorch/cu102/libtorch-shared-with-deps-1.9.1%2Bcu102.zip -o libtorch.zip \
    && unzip libtorch.zip -d /usr/local \
    && rm libtorch.zip

# Set environment variables for CMake to find LibTorch
ENV TORCH_HOME=/usr/local/libtorch
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/libtorch/lib

# Set working directory
WORKDIR /workspace

COPY . .

# Run the install script and compile your C++ code
RUN chmod +x /workspace/install.sh && \
    /workspace/install.sh && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make

# Default command can be a build script or simply a shell
CMD ["/bin/bash"]
