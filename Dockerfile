FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

# Install Dependencies
RUN apt-get autoremove && apt-get clean && apt-get update -y && apt-get install -y \
    git wget cmake \
    libmicrohttpd-dev libjansson-dev \
    libssl-dev libsofia-sip-ua-dev libglib2.0-dev \
    libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev \
    libconfig-dev pkg-config gengetopt libtool automake

# Install libnice
RUN apt-get install -y python3-pip && \
    pip3 install meson ninja && \
    git clone https://gitlab.freedesktop.org/libnice/libnice ~/libnice && \
    cd ~/libnice && \
    meson --prefix=/usr build && ninja -C build && ninja -C build install

# Install libsrtp
RUN cd ~ && \
    wget https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz && \
    tar xfv v2.2.0.tar.gz && \
    cd libsrtp-2.2.0 && \
    ./configure --prefix=/usr --enable-openssl && \
    make shared_library && make install

# Install libwebsockets
RUN git clone https://libwebsockets.org/repo/libwebsockets ~/libwebsockets && \
    cd ~/libwebsockets && \
    mkdir build && cd build && \
    cmake -DLWS_MAX_SMP=1 -DLWS_WITHOUT_EXTENSIONS=0 -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" .. && \
    make && make install

# Install usrsctp
RUN git clone https://github.com/sctplab/usrsctp ~/usrsctp && \
    cd ~/usrsctp && \
    ./bootstrap && \
    ./configure --prefix=/usr --disable-programs --disable-inet --disable-inet6 && \
    make && make install

# Install nginx
RUN apt-get install -y nginx

# Install janus-gateway
RUN git clone https://github.com/meetecho/janus-gateway.git -b v0.10.7 --depth 1 ~/janus-gateway && \
    cd ~/janus-gateway && \
    ./autogen.sh && \
    ./configure --prefix=/opt/janus && \
    make && make install && make configs && \
    cp -r ~/janus-gateway/html /var/www/ && \
    sed -i -e 's/gatewayCallbacks\.server/`ws:\/\/${window.location.hostname}:8188`/g' /var/www/html/janus.js
COPY janus.jcfg /opt/janus/etc/janus/janus.jcfg

ENTRYPOINT nginx && /opt/janus/bin/janus
