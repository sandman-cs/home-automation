# Use Oracle Linux 9 as the base image
FROM oraclelinux:9

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

RUN dnf -y install https://download.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
    && dnf install yum-utils -y \
# Add the EPEL repository
    && dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm -y \
    && dnf install --nogpgcheck https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-9.noarch.rpm -y


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
    #libavfilter-free \
    #ffmpeg-free \
    vlc-plugin-ffmpeg \
    libtiff \
    gcc \
    make \
    git \
    && dnf clean all


# Install additional dependencies for Home Assistant
# Upgrade pip
# RUN python3.12 -m pip install --upgrade pip
RUN rm -f /usr/bin/python3   
RUN ln -s /usr/bin/python3.12 /usr/bin/python3

# Create Home Assistant user
RUN useradd -m homeassistant \
    && usermod -aG wheel homeassistant \
    && mkdir -p /srv/homeassistant \
    && chown -R homeassistant:homeassistant /srv/homeassistant \
    && chmod -R 755 /srv/homeassistant \
    && su -u homeassistant -H -s \
    && cd /srv/homeassistant \
    && python3.12 -m venv . \
    && . bin/activate \
    && source bin/activate

# Install Home Assistant in the virtual environment
RUN pip install --upgrade pip \
    && pip install wheel \
    && pip install homeassistant

# Set working directory
WORKDIR /home/homeassistant

# Install Home Assistant
RUN pip3 install homeassistant

# Expose default Home Assistant port
EXPOSE 8123

# Run Home Assistant
CMD ["python3", "-m", "homeassistant"]
