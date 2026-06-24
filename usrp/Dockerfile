FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# =========================
# Step 1 : update with retries
# =========================
RUN apt-get update -o Acquire::Retries=5 -o Acquire::http::Timeout=30

# =========================
# Step 2 : certificates only
# =========================
RUN apt-get install -y -o Acquire::Retries=5 --no-install-recommends \
    ca-certificates

# =========================
# Base tools
# =========================
RUN apt-get update -o Acquire::Retries=5 -o Acquire::http::Timeout=30 && \
    apt-get install -y -o Acquire::Retries=5 --no-install-recommends \
    net-tools zsh wireshark iptables nano inetutils-ping \
    git wget tmux curl

# =========================
# UHD / USRP
# =========================
RUN apt-get update -o Acquire::Retries=5 -o Acquire::http::Timeout=30 && \
    apt-get install -y -o Acquire::Retries=5 --no-install-recommends \
    uhd-host \
    libuhd-dev

RUN uhd_images_downloader || true

# =========================
# Build dependencies
# =========================
RUN apt-get update -o Acquire::Retries=5 -o Acquire::http::Timeout=30 && \
    apt-get install -y -o Acquire::Retries=5 --no-install-recommends \
    build-essential \
    cmake \
    g++ \
    autoconf \
    automake \
    libtool \
    pkg-config \
    swig \
    python3-dev \
    libxml2 libxml2-dev \
    bison flex \
    libcdk5-dev \
    libusb-1.0-0-dev \
    libaio-dev \
    libfftw3-dev \
    libsctp-dev \
    libboost-program-options-dev \
    libconfig++-dev \
    libboost-all-dev \
    libzmq3-dev \
    libreadline-dev \
    libncurses5-dev \
    libssl-dev \
    libosmocore-dev \
    libosmocore

# =========================
# Osmocom stack
# =========================
RUN apt-get update -o Acquire::Retries=5 -o Acquire::http::Timeout=30 && \
    apt-get install -y -o Acquire::Retries=5 --no-install-recommends \
    osmo-bts \
    osmo-hlr \
    osmo-stp \
    osmo-msc \
    osmo-mgw \
    osmo-bsc

# =========================
# Build OsmoTRX UHD
# =========================
WORKDIR /osmobts

RUN git clone https://github.com/SitrakaResearchAndPOC/fork_osmo-trx_soapy.git

WORKDIR /osmobts/fork_osmo-trx_soapy

RUN autoreconf -fi && \
    ./configure --with-uhd --without-lms --without-soapy-trx && \
    make -j$(nproc) && \
    make install && \
    ldconfig

# =========================
# Config download
# =========================
WORKDIR /osmobts

RUN wget https://raw.githubusercontent.com/SitrakaResearchAndPOC/nitb-script-all/main/osmo-trx-uhd.cfg

# =========================
# Patch start script
# =========================
WORKDIR /osmobts/fork_osmo-trx_soapy/Osmocom_configs/VOICE

RUN sed -i "/DIR=\/home\/user1\/GSM\/osmo_trx_soapy\/Transceiver52M/d" start_base.sh && \
    sed -i "s#\$DIR/osmo-trx-soapy -C \$DIR/test1.cfg#osmo-trx-uhd -C /osmobts/osmo-trx-uhd.cfg#g" start_base.sh

RUN cp -rf start_base.sh start_network_ran.sh && \
cp -rf start_master.sh start_network_core.sh

# =========================
# cleanup final
# =========================
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /osmobts
CMD ["/bin/bash"]
