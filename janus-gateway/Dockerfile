FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

# Install Dependencies
RUN apt-get update -y && apt-get install -y \
    git wget cmake \
    libmicrohttpd-dev libjansson-dev \
    libssl-dev libsofia-sip-ua-dev libglib2.0-dev \
    libopus-dev libogg-dev libcurl4-openssl-dev liblua5.3-dev \
    libconfig-dev pkg-config gengetopt libtool automake \
    python3-pip

# Install libnice
RUN pip3 install meson ninja && \
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

# Install janus-gateway
RUN git clone https://github.com/meetecho/janus-gateway.git -b 0.10.7 --depth 1 ~/janus-gateway && \
    cd ~/janus-gateway && \
    ./autogen.sh && \
    ./configure --prefix=/opt/janus && \
    make && make install && make configs
COPY janus.jcfg /opt/janus/etc/janus/janus.jcfg

# Create user
ARG user=janus
ARG group=janus
ARG uid=1000
ARG gid=1000
RUN groupadd -g ${gid} ${group} && \
    useradd -u ${uid} -g ${gid} -m ${user}
USER ${user}

EXPOSE 8188
ENTRYPOINT /opt/janus/bin/janus
