ARG BASE_IMAGE=ubuntu:22.04
From $BASE_IMAGE

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=ubuntu \
    PASSWORD=ubuntu \
    UID=1000 \
    GID=1000

ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV VGL_DISPLAY=egl
ENV REMOTE_DESKTOP=nomachine
ENV VNC_THREADS=2

## Copy config
COPY config /config

## Install and Configure OpenGL
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libxau6 libxdmcp6 libxcb1 libxext6 libx11-6 \
        libglvnd0 libgl1 libglx0 libegl1 libgles2 \
        libglvnd-dev libgl1-mesa-dev libegl1-mesa-dev libgles2-mesa-dev && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /usr/share/glvnd/egl_vendor.d/ && \
    echo "{\n\
\"file_format_version\" : \"1.0.0\",\n\
\"ICD\": {\n\
    \"library_path\": \"libEGL_nvidia.so.0\"\n\
}\n\
}" > /usr/share/glvnd/egl_vendor.d/10_nvidia.json


## Install some common tools 
RUN apt-get update  && \
    apt-get install -y sudo vim gedit locales wget curl git git-lfs gnupg2 lsb-release net-tools iputils-ping mesa-utils \
                    openssh-server bash-completion software-properties-common python3-pip python3-numpy tmux && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 2 && \
    pip3 install --upgrade pip &&\
    rm -rf /var/lib/apt/lists/* 

## Install desktop
RUN apt-get update && \
    # add apt repo for firefox
    add-apt-repository -y ppa:mozillateam/ppa &&\
    mkdir -p /etc/apt/preferences.d &&\
    echo "Package: firefox*\n\
Pin: release o=LP-PPA-mozillateam\n\
Pin-Priority: 1001" > /etc/apt/preferences.d/mozilla-firefox &&\
    # install xfce4 and firefox
    apt-get install -y xfce4 terminator fonts-wqy-zenhei ffmpeg firefox &&\
    # remove and disable screensaver
    apt-get remove -y xfce4-screensaver --purge &&\
    # set firefox as default web browser
    update-alternatives --set x-www-browser /usr/bin/firefox &&\
    rm -rf /var/lib/apt/lists/*

## Install nomachine
RUN bash /config/install_nomachine.sh &&\
    groupmod -g 2000 nx 

## Install kasmvnc
RUN bash /config/install_kasmvnc.sh &&\
    rm -rf /var/lib/apt/lists/*

## Configure ssh 
RUN mkdir /var/run/sshd &&  \
    echo root:$PASSWORD | chpasswd && \
    sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

EXPOSE 22 4000

ENTRYPOINT ["/config/entrypoint.sh"]
