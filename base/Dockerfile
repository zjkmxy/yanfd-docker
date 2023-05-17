ARG VARIANT="jammy"
FROM buildpack-deps:${VARIANT}-curl

ENV DEBIAN_FRONTEND=noninteractive

LABEL dev.containers.features="common"

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
    python3-dev \
    python3-pip \
    libboost-all-dev \
    libssl-dev \
    libsqlite3-dev \
    libpcap-dev \
    dpkg-dev \
    psmisc \
    g++ \
    gcc \
    gdb \
    libc6-dev && \
    apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Go: from https://github.com/docker-library/golang/blob/master/1.20/buster/Dockerfile
ENV PATH /usr/local/go/bin:$PATH
ENV GOLANG_VERSION 1.20.4

RUN set -eux; \
    arch="$(dpkg --print-architecture)"; arch="${arch##*-}"; \
    url=; \
    case "$arch" in \
    'amd64') \
    url='https://dl.google.com/go/go1.20.4.linux-amd64.tar.gz'; \
    sha256='698ef3243972a51ddb4028e4a1ac63dc6d60821bf18e59a807e051fee0a385bd'; \
    ;; \
    'armel') \
    export GOARCH='arm' GOARM='5' GOOS='linux'; \
    ;; \
    'armhf') \
    url='https://dl.google.com/go/go1.20.4.linux-armv6l.tar.gz'; \
    sha256='0b75ca23061a9996840111f5f19092a1bdbc42ec1ae25237ed2eec1c838bd819'; \
    ;; \
    'arm64') \
    url='https://dl.google.com/go/go1.20.4.linux-arm64.tar.gz'; \
    sha256='105889992ee4b1d40c7c108555222ca70ae43fccb42e20fbf1eebb822f5e72c6'; \
    ;; \
    'i386') \
    url='https://dl.google.com/go/go1.20.4.linux-386.tar.gz'; \
    sha256='5dfa3db9433ef6a2d3803169fb4bd2f4505414881516eb9972d76ab2e22335a7'; \
    ;; \
    'mips64el') \
    export GOARCH='mips64le' GOOS='linux'; \
    ;; \
    'ppc64el') \
    url='https://dl.google.com/go/go1.20.4.linux-ppc64le.tar.gz'; \
    sha256='8c6f44b96c2719c90eebabe2dd866f9c39538648f7897a212cac448587e9a408'; \
    ;; \
    's390x') \
    url='https://dl.google.com/go/go1.20.4.linux-s390x.tar.gz'; \
    sha256='57f999a4e605b1dfa4e7e58c7dbae47d370ea240879edba8001ab33c9a963ebf'; \
    ;; \
    *) echo >&2 "error: unsupported architecture '$arch' (likely packaging update needed)"; exit 1 ;; \
    esac; \
    build=; \
    if [ -z "$url" ]; then \
    # https://github.com/golang/go/issues/38536#issuecomment-616897960
    build=1; \
    url='https://dl.google.com/go/go1.20.4.src.tar.gz'; \
    sha256='9f34ace128764b7a3a4b238b805856cc1b2184304df9e5690825b0710f4202d6'; \
    echo >&2; \
    echo >&2 "warning: current architecture ($arch) does not have a compatible Go binary release; will be building from source"; \
    echo >&2; \
    fi; \
    \
    wget -O go.tgz.asc "$url.asc"; \
    wget -O go.tgz "$url" --progress=dot:giga; \
    echo "$sha256 *go.tgz" | sha256sum -c -; \
    \
    # https://github.com/golang/go/issues/14739#issuecomment-324767697
    GNUPGHOME="$(mktemp -d)"; export GNUPGHOME; \
    # https://www.google.com/linuxrepositories/
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 'EB4C 1BFD 4F04 2F6D DDCC  EC91 7721 F63B D38B 4796'; \
    # let's also fetch the specific subkey of that key explicitly that we expect "go.tgz.asc" to be signed by, just to make sure we definitely have it
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys '2F52 8D36 D67B 69ED F998  D857 78BD 6547 3CB3 BD13'; \
    gpg --batch --verify go.tgz.asc go.tgz; \
    gpgconf --kill all; \
    rm -rf "$GNUPGHOME" go.tgz.asc; \
    \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz; \
    \
    if [ -n "$build" ]; then \
    savedAptMark="$(apt-mark showmanual)"; \
    # add backports for newer go version for bootstrap build: https://github.com/golang/go/issues/44505
    ( \
    . /etc/os-release; \
    echo "deb https://deb.debian.org/debian $VERSION_CODENAME-backports main" > /etc/apt/sources.list.d/backports.list; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends -t "$VERSION_CODENAME-backports" golang-go; \
    ); \
    \
    export GOCACHE='/tmp/gocache'; \
    \
    ( \
    cd /usr/local/go/src; \
    # set GOROOT_BOOTSTRAP + GOHOST* such that we can build Go successfully
    export GOROOT_BOOTSTRAP="$(go env GOROOT)" GOHOSTOS="$GOOS" GOHOSTARCH="$GOARCH"; \
    ./make.bash; \
    ); \
    \
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark > /dev/null; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*; \
    \
    # remove a few intermediate / bootstrapping files the official binary release tarballs do not contain
    rm -rf \
    /usr/local/go/pkg/*/cmd \
    /usr/local/go/pkg/bootstrap \
    /usr/local/go/pkg/obj \
    /usr/local/go/pkg/tool/*/api \
    /usr/local/go/pkg/tool/*/go_bootstrap \
    /usr/local/go/src/cmd/dist/dist \
    "$GOCACHE" \
    ; \
    fi; \
    \
    go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"

# Install ndn things

RUN python3 -m pip install --upgrade setuptools && \
    python3 -m pip install python-ndn[dev,pyca] && \
    git clone --depth=1 --recursive --branch ndn-cxx-0.8.1 https://github.com/named-data/ndn-cxx.git && \
    cd ndn-cxx && \
    ./waf configure && \
    ./waf -j4 && \
    ./waf install && \
    ldconfig && \
    rm -rf ndn-cxx && \
    git clone --depth=1 --recursive --branch NFD-22.12 https://github.com/named-data/NFD.git && \
    cd NFD && \
    ./waf configure && \
    ./waf -j2 && \
    ./waf install && \
    cp /usr/local/etc/ndn/nfd.conf.sample /usr/local/etc/ndn/nfd.conf && \
    rm -rf NFD && \
    git clone --depth=1 --recursive --branch ndn-tools-22.12 https://github.com/named-data/ndn-tools.git && \
    cd ndn-tools && \
    ./waf configure && \
    ./waf -j2 && \
    ./waf install && \
    rm -rf ndn-tools && \
    mkdir -p /usr/local/etc/ndn && \
    sudo cp /usr/local/etc/ndn/nfd.conf.sample /usr/local/etc/ndn/nfd.conf && \
    ndnsec key-gen /develop | ndnsec cert-install -
