# Use Oracle Linux 9 as the base image
FROM oraclelinux:9

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Install dependencies
RUN dnf -y update \
    && dnf install -y \
    epel-release \
    python3.12 \
    python3.12-pip \
    python3.12-setuptools \
    python3.12-wheel \
    libffi-devel \
    openssl-devel \
    bluez \
    tzdata \
    autoconf \
    ffmpeg-free \
    gcc \
    make \
    git \
    && dnf clean all


# Install additional dependencies for Home Assistant
# Upgrade pip
RUN python3.12 -m pip install --upgrade pip
RUN rm -f /usr/bin/python3   
RUN ln -s /usr/bin/python3.12 /usr/bin/python3

# Create Home Assistant user
RUN useradd -m homeassistant

# Set working directory
WORKDIR /home/homeassistant

# Install Home Assistant
RUN pip3 install homeassistant

# Expose default Home Assistant port
EXPOSE 8123

# Run Home Assistant
CMD ["python3", "-m", "homeassistant"]
