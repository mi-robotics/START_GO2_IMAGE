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

# Download and extract LibTorch (PyTorch C++ API) for Jetson
# Make sure to choose the correct version for your CUDA and compute capability

RUN curl -L https://download.pytorch.org/libtorch/cu102/libtorch-shared-with-deps-1.9.1%2Bcu102.zip -o libtorch.zip \
    && unzip libtorch.zip -d /usr/local \
    && rm libtorch.zip

# Set environment variables for CMake to find LibTorch
ENV TORCH_HOME=/usr/local/libtorch
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/libtorch/lib

# (Optional) Add Unitree SDK and your project files
# ADD path/to/UNITREE_SDK /path/in/container/UNITREE_SDK
# ADD your/project/files /path/in/container/project

# Set working directory
WORKDIR /workspace

# Default command can be a build script or simply a shell
CMD ["/bin/bash"]
