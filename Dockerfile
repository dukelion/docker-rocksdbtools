FROM golang:1.8-alpine

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >>/etc/apk/repositories
RUN echo "@community http://nl.alpinelinux.org/alpine/edge/community" >>/etc/apk/repositories
RUN apk add --update --no-cache build-base linux-headers git cmake bash #wget mercurial g++ autoconf libgflags-dev cmake  bash jemalloc
RUN apk add --update --no-cache zlib zlib-dev bzip2 bzip2-dev snappy snappy-dev lz4 lz4-dev zstd@community zstd-dev@community jemalloc jemalloc-dev libtbb-dev@testing libtbb@testing

# installing latest gflags
RUN cd /tmp && \
    git clone https://github.com/gflags/gflags.git && \
    cd gflags && \
    mkdir build && \
    cd build && \
    cmake -DBUILD_SHARED_LIBS=1 -DGFLAGS_INSTALL_SHARED_LIBS=1 .. && \
    make install && \
    cd /tmp && \
    rm -R /tmp/gflags/

# Install Rocksdb
RUN cd /tmp && \
    git clone https://github.com/facebook/rocksdb.git && \
    cd rocksdb && \
    git checkout v5.7.1 && \
    make tools && \
    cp /tmp/rocksdb/tools/{ldb,sst_dump} /usr/bin/

FROM alpine
MAINTAINER Vasilii Alferov <vasilii@iron.io>

COPY --from=0 /usr/bin/{ldb,sst_dump} /usr/bin/


