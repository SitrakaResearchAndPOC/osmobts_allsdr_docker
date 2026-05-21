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
# SOAPY INSTEAD UHD / USRP
# =========================
RUN mkdir -p /opt/src

# Variables d’environnement
ENV SRS_INSTALL=/root/srs
ENV LD_LIBRARY_PATH=/root/srs/lib:${LD_LIBRARY_PATH}
ENV PKG_CONFIG_PATH=/root/srs/lib/pkgconfig:${PKG_CONFIG_PATH}
ENV SOAPY_SDR_PLUGIN_PATH=/root/srs/lib/SoapySDR/modules0.8

# Création du répertoire d’installation
RUN mkdir -p ${SRS_INSTALL}

# Ajouter automatiquement dans bashrc
RUN echo 'export SRS_INSTALL=$HOME/srs' >> /root/.bashrc && \
    echo 'export LD_LIBRARY_PATH=$SRS_INSTALL/lib:$LD_LIBRARY_PATH' >> /root/.bashrc && \
    echo 'export PKG_CONFIG_PATH=$SRS_INSTALL/lib/pkgconfig:$PKG_CONFIG_PATH' >> /root/.bashrc && \
    echo 'export SOAPY_SDR_PLUGIN_PATH=$SRS_INSTALL/lib/SoapySDR/modules0.8' >> /root/.bashrc


WORKDIR /opt/src

# =========================================================
# SOAPY INSTEAD UHD
# =========================================================
# Télécharger SoapySDR
WORKDIR /opt/src

RUN git clone \
    --depth 1 \
    --branch soapy-sdr-0.8.1 \
    https://github.com/pothosware/SoapySDR.git

# Compilation et installation
WORKDIR /opt/src

RUN cd SoapySDR && \
    mkdir build && \
    cd build && \
    cmake \
        -DCMAKE_INSTALL_PREFIX=${SRS_INSTALL} \
        -DCMAKE_PREFIX_PATH=${SRS_INSTALL} \
        .. && \
    make -j$(nproc) && \
    make install
    
 
 
# Télécharger libiio
WORKDIR /opt/src

RUN git clone \
    --depth 1 \
    --branch v0.24 \
    https://github.com/analogdevicesinc/libiio.git

# Compilation et installation
WORKDIR /opt/src

RUN cd libiio && \
    mkdir build && \
    cd build && \
    cmake \
        -DCMAKE_INSTALL_PREFIX=${SRS_INSTALL} \
        -DCMAKE_PREFIX_PATH=${SRS_INSTALL} \
        -DUDEV_RULES_INSTALL_DIR=${SRS_INSTALL}/etc/udev/rules.d \
        -DHAVE_DNS_SD=OFF \
        .. && \
    make -j$(nproc) && \
    make install
    
       
# Télécharger libad9361-iio
WORKDIR /opt/src

RUN git clone \
    --depth 1 \
    --branch v0.3 \
    https://github.com/analogdevicesinc/libad9361-iio.git

# Compilation et installation
WORKDIR /opt/src

RUN cd libad9361-iio && \
    mkdir build && \
    cd build && \
    cmake \
        -DCMAKE_INSTALL_PREFIX=${SRS_INSTALL} \
        -DCMAKE_PREFIX_PATH=${SRS_INSTALL} \
        .. && \
    make -j$(nproc) && \
    make install

# Télécharger SoapyPlutoSDR timestamping
WORKDIR /opt/src

RUN git clone \
    --depth 1 \
    --branch sdr_gadget_timestamping \
    https://github.com/pgreenland/SoapyPlutoSDR.git

# Compilation et installation
WORKDIR /opt/src

RUN cd SoapyPlutoSDR && \
	sed -i 's/CXX_COMPILER_ID:GNU,Clang,AppleClang/OR:$<CXX_COMPILER_ID:GNU>,$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>>/g' CMakeLists.txt && \
    mkdir build && \
    cd build && \
    cmake \
        -DCMAKE_INSTALL_PREFIX=${SRS_INSTALL} \
        -DCMAKE_PREFIX_PATH=${SRS_INSTALL} \
        .. && \
    make -j$(nproc) && \
    make install



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
