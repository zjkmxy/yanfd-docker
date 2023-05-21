FROM yanfd-docker-base:latest

LABEL org.opencontainers.image.source "https://github.com/zjkmxy/YaNFD-docker"
LABEL org.opencontainers.image.authors "Xinyu Ma"
LABEL org.opencontainers.image.title "NDN Development Docker"
LABEL org.opencontainers.image.description \
    "General Docker for NDN development, with NFD, python-ndn, YaNFD and ndn-tools installed"


ENV DEBIAN_FRONTEND=noninteractive

COPY yanfd.toml /usr/local/etc/ndn

RUN git clone https://github.com/zjkmxy/YaNFD.git \
    && cd YaNFD \
    && make \
    && make install
