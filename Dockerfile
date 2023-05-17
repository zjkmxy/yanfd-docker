FROM yanfd-docker-base:latest

LABEL org.opencontainers.image.source = "https://github.com/zjkmxy/YaNFD-docker"
LABEL org.opencontainers.image.authors = "Xinyu Ma"
LABEL org.opencontainers.image.title = "YaNFD Docker with other NDN tools for development and codespaces"


ENV DEBIAN_FRONTEND=noninteractive

COPY yanfd.toml /usr/local/etc/ndn

RUN git clone https://github.com/zjkmxy/YaNFD.git \
    && cd YaNFD \
    && make

