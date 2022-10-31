FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
    autoconf \
    build-essential \
    sudo \
    wget \
    curl \
    git-all \
    iproute2 \
    iputils-ping \
    net-tools \
    netcat \
    tcpdump \
    pkg-config \
    python3 \
    python3-pip \
    libboost-all-dev \
    libssl-dev \
    libsqlite3-dev \
    libpcap-dev \
    golang-go \
    dpkg-dev \
    psmisc

RUN pip3 install python-ndn

RUN git clone --depth=1 --recursive --branch ndn-cxx-0.8.0 https://github.com/named-data/ndn-cxx.git && \
    cd ndn-cxx && \
    ./waf configure && \
    ./waf -j4 && \
    ./waf install && \
    ldconfig && \
    rm -rf ndn-cxx
RUN git clone --depth=1 --recursive --branch NFD-22.02 https://github.com/named-data/NFD.git && \
    cd NFD && \
    ./waf configure && \
    ./waf -j2 && \
    ./waf install && \
    cp /usr/local/etc/ndn/nfd.conf.sample /usr/local/etc/ndn/nfd.conf && \
    rm -rf NFD
RUN git clone --depth=1 --recursive --branch ndn-tools-22.02 https://github.com/named-data/ndn-tools.git && \
    cd ndn-tools && \
    ./waf configure && \
    ./waf -j2 && \
    ./waf install && \
    rm -rf ndn-tools

RUN mkdir -p /usr/local/etc/ndn

