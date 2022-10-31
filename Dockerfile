FROM yanfd-docker-base:latest

ENV DEBIAN_FRONTEND=noninteractive

COPY yanfd.toml /usr/local/etc/ndn

RUN git clone https://github.com/zjkmxy/YaNFD.git \
    && cd YaNFD \
    && make

