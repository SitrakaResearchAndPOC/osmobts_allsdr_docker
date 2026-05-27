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
# Base system + build deps
# =========================
RUN apt-get update && apt-get install -y -o Acquire::Retries=5 --no-install-recommends \
    git \
    build-essential \
    cmake \
    g++ \
    autoconf \
    automake \
    libtool \
    pkg-config \
    swig \
    python3-dev \
    libxml2 \
    libxml2-dev \
    bison \
    flex \
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
    wget \
    curl \
    ca-certificates 

RUN apt-get update -o Acquire::Retries=5 -o Acquire::http::Timeout=30 && \
    apt-get install -y -o Acquire::Retries=5 --no-install-recommends \
    python3-setuptools python3-pip

RUN apt-get update -o Acquire::Retries=5 -o Acquire::http::Timeout=30 && \
    apt-get install -y --no-install-recommends \
    software-properties-common && \
    add-apt-repository universe && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    cmake \
    ninja-build \
    g++ \
    git \
    wget \
    curl \
    tmux \
    nano \
    zsh \
    net-tools \
    iptables \
    inetutils-ping \
    wireshark \
    autoconf \
    automake \
    libtool \
    pkg-config \
    swig \
    python3 \
    python3-dev \
    python3-setuptools \
    python3-pip \
    bison \
    flex \
    sudo \
    libxml2 \
    libxml2-dev \
    libcdk5-dev \
    libusb-1.0-0-dev \
    libaio-dev \
    libfftw3-dev \
    libsctp-dev \
    libboost-program-options-dev \
    libboost-all-dev \
    libconfig++-dev \
    libzmq3-dev \
    libreadline-dev \
    libncurses5-dev \
    libssl-dev \
    libmbedtls-dev \
    libosmocore-dev \
    libsoapysdr-dev \
    soapysdr-tools \
    libiio-dev \
    libiio-utils

WORKDIR /opt/src

# =========================================================
# SOAPY INSTEAD UHD
# =========================================================

# =========================================================
# libad9361-iio
# =========================================================
WORKDIR /opt/src

RUN git clone \
    --depth 1 \
    --branch v0.3 \
    https://github.com/analogdevicesinc/libad9361-iio.git

RUN cd libad9361-iio && \
    mkdir -p build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig

# =========================================================
# SoapyPlutoSDR (timestamping branch)
# =========================================================
WORKDIR /opt/src

RUN git clone \
    --depth 1 \
    --branch sdr_gadget_timestamping \
    https://github.com/pgreenland/SoapyPlutoSDR.git

RUN cd SoapyPlutoSDR && \
    sed -i \
    's/CXX_COMPILER_ID:GNU,Clang,AppleClang/OR:$<CXX_COMPILER_ID:GNU>,$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>>/g' \
    CMakeLists.txt && \
    mkdir -p build && \
    cd build && \
    cmake .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig
 


# =========================================================
# No Download USRP Images
# =========================================================


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

# Télécharger fork osmo-trx Soapy
RUN git clone \
    --depth 1 \
    https://github.com/SitrakaResearchAndPOC/fork_osmo-trx_soapy.git

# Compilation et installation
RUN cd fork_osmo-trx_soapy && \
    autoreconf -fi && \
    ./configure \
        --without-uhd \
        --without-lms \
        --with-soapy-trx && \
    make -j$(nproc) && \
    make install

# =========================
# Patch start script
# =========================
WORKDIR /osmobts/fork_osmo-trx_soapy/Osmocom_configs/VOICE

RUN sed -i "/DIR=\/home\/user1\/GSM\/osmo_trx_soapy\/Transceiver52M/d" start_base.sh && \
    sed -i "s#\$DIR/osmo-trx-soapy -C \$DIR/test1.cfg#osmo-trx-soapy -C /osmobts/fork_osmo-trx_soapy/Transceiver52M/test1.cfg#g" start_base.sh



# =========================
# cleanup final
# =========================
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /osmobts
CMD ["/bin/bash"]
