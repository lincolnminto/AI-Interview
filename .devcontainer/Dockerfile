FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

# Install Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - \
    && apt-get update \
    && apt-get install -y nodejs

# Install Python 3.9 (matching WebApp Dockerfile) and development tools
RUN apt-get update && apt-get install -y \
    python3.9 \
    python3.9-dev \
    python3-pip \
    python3.9-venv \
    build-essential \
    cmake \
    pkg-config \
    gcc \
    libportaudio2 \
    libportaudiocpp0 \
    portaudio19-dev \
    libasound-dev \
    libsndfile1-dev \
    libgl1-mesa-dev \
    libjpeg-dev \
    libtiff5-dev \
    libpng-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libgtk-3-dev \
    libatlas-base-dev \
    gfortran \
    libhdf5-dev \
    libhdf5-serial-dev \
    libhdf5-103 \
    libjpeg8-dev \
    liblapack-dev \
    libblas-dev \
    libopenblas-dev \
    libssl-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Create symlinks for python3.9 to match WebApp environment
RUN ln -sf /usr/bin/python3.9 /usr/local/bin/python \
    && ln -sf /usr/bin/python3.9 /usr/local/bin/python3

# Upgrade pip and install common packages
RUN python -m pip install --upgrade pip \
    && pip install --no-cache-dir \
    wheel \
    setuptools \
    pyaudio \
    dlib

# Set working directory
WORKDIR /workspace

# Create a non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*

# Switch to non-root user
USER $USERNAME

# Set environment variables
ENV PYTHONPATH=/workspace
ENV NODE_ENV=development
ENV PIP_DEFAULT_TIMEOUT=100
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PYTHONFAULTHANDLER=1