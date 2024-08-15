FROM ubuntu:24.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata

ENV PATH="/root/.local/bin:$PATH"

ENV PATH="/root/.local/bin:$PATH"

# Install Dependencies
RUN apt-get install -y \
    git wget cmake build-essential \
    libmicrohttpd-dev libjansson-dev \
    libssl-dev libsofia-sip-ua-dev libglib2.0-dev \
    libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev \
    libconfig-dev pkg-config gengetopt libtool automake \
    pipx && \
    rm -rf /var/lib/apt/lists/*

# Install libnice
RUN pipx install meson ninja && \
    git clone https://gitlab.freedesktop.org/libnice/libnice ~/libnice && \
    cd ~/libnice && \
    meson --prefix=/usr build && ninja -C build && ninja -C build install && \
    rm -rf ~/libnice

# Install libsrtp
RUN cd ~ && \
    wget https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz && \
    tar xfv v2.2.0.tar.gz && \
    cd libsrtp-2.2.0 && \
    ./configure --prefix=/usr --enable-openssl && \
    make shared_library && make install && \
    rm -rf ~/libsrtp-2.2.0 v2.2.0.tar.gz

# Install libwebsockets
RUN git clone https://github.com/warmcat/libwebsockets.git ~/libwebsockets && \
    cd ~/libwebsockets && \
    mkdir build && cd build && \
    cmake -DLWS_MAX_SMP=1 -DLWS_WITHOUT_EXTENSIONS=0 -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" .. && \
    make && make install && \
    rm -rf ~/libwebsockets

# Install usrsctp
RUN git clone https://github.com/sctplab/usrsctp ~/usrsctp && \
    cd ~/usrsctp && \
    ./bootstrap && \
    ./configure --prefix=/usr --disable-programs --disable-inet --disable-inet6 && \
    make && make install && \
    rm -rf ~/usrsctp

# Install janus-gateway
RUN git clone https://github.com/meetecho/janus-gateway.git --depth 1 ~/janus-gateway && \
    cd ~/janus-gateway && \
    ./autogen.sh && \
    ./configure --prefix=/opt/janus && \
    make && make install && make configs && \
    rm -rf ~/janus-gateway

COPY janus.jcfg /opt/janus/etc/janus/janus.jcfg

# Create user
ARG user=janus
ARG group=janus
ARG uid=1001
ARG gid=1001
RUN groupadd -g ${gid} ${group} && \
    useradd -u ${uid} -g ${gid} -m ${user}
USER ${user}

EXPOSE 8188
ENTRYPOINT /opt/janus/bin/janus -L /dev/null
