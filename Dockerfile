# Use Oracle Linux 9 as the base image
FROM oraclelinux:9

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
    && mkdir /srv/homeassistant \
    && chown homeassistant:homeassistant /srv/homeassistant \
    && chmod 755 /srv/homeassistant
# Create a virtual environment for Home Assistant
# Switch to the Home Assistant user
USER homeassistant
#RUN su homeassistant -H -s 
RUN cd /srv/homeassistant 
RUN python3.12 -m venv /srv/homeassistant \
    && source /srv/homeassistant/bin/activate \
    && pip install --upgrade pip \
    && pip install wheel \
    && pip install homeassistant
# RUN cd /srv/homeassistant 
#     # && python3.12 -m venv . \
#     # && source bin/activate
# RUN pip install --upgrade pip 
# RUN pip install wheel 
# RUN pip install homeassistant

# Install Home Assistant in the virtual environment
# RUN pip install --upgrade pip \
#     && pip install wheel \
#     && pip install homeassistant

# Set working directory
WORKDIR /home/homeassistant

# Expose default Home Assistant port
EXPOSE 8123

# Run Home Assistant
CMD ["/srv/homeassistant/bin/hass", "--open-ui"]
