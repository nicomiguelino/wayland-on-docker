FROM balenalib/raspberrypi5-debian:bookworm

RUN sudo apt-get -y update && \
    sudo apt-get install -y \
        seatd \
        wayfire \
        mesa-utils \
        libgl1-mesa-dri \
        binutils \
        mesa-vulkan-drivers \
        libgbm-dev \
        mesa-utils-extra \
        xwayland \
        libxcb1 \
        libxcb-composite0 \
        libxcb-xfixes0

# Create a non-root user
RUN useradd -m -s /bin/bash devuser && \
    echo "devuser:devuser" | chpasswd && \
    adduser devuser sudo

RUN sudo usermod -a -G tty,video,input,render devuser

RUN echo "devuser ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/devuser

# Create log directory with appropriate permissions
RUN sudo mkdir -p /var/log/wayfire && \
    sudo chown devuser:devuser /var/log/wayfire && \
    sudo chmod 755 /var/log/wayfire

# Set the default user
USER devuser
WORKDIR /home/devuser

# Setup Wayland environment
ENV XDG_RUNTIME_DIR=/tmp/runtime-devuser
ENV WLR_RENDERER=pixman
ENV WLR_NO_HARDWARE_CURSORS=1
ENV WLR_BACKENDS=drm
ENV WLR_DRM_NO_ATOMIC=1
ENV WLR_RENDERER_ALLOW_SOFTWARE=1

RUN mkdir -p ${XDG_RUNTIME_DIR} && \
    chmod 0700 ${XDG_RUNTIME_DIR}

COPY ./bin/start.sh /home/devuser/start.sh
CMD [ "bash", "/home/devuser/start.sh" ]
