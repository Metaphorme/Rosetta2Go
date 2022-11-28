# Rosetta2Go
# https://github.com/Metaphorme/Rosetta2Go
# MIT License
# Copyright (c) 2022 Metaphorme <https://github.com/Metaphorme>

FROM alpine:3.12


LABEL org.opencontainers.image.authors="Metaphorme" \
      org.opencontainers.image.documentation="https://github.com/Metaphorme/Rosetta2Go"

ARG DEBIAN_FRONTEND=noninteractive

ENV PATH=/rosetta/source/bin:$PATH \
    LIB_LIBRARY_PATH=/rosetta/source/external/lib:$LIB_LIBRARY_PATH \
    PATH=$PATH:/usr/local/openmpi/bin \
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/openmpi/lib \
    OMPI_ALLOW_RUN_AS_ROOT=1 \
    OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

COPY rosetta_src_3.13_bundle.tgz /tmp

VOLUME /data

RUN set -x; buildDeps='libexecinfo libexecinfo-dev build-base curl coreutils python3 libc6-compat pigz perl linux-headers bash zlib-dev vim nano' \
    && sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories \
    && apk --update add --no-cache $buildDeps \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && cd /tmp \
    && curl -SL https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.4.tar.bz2 | tar -xjv; cd openmpi-4.1.4 \
    && ./configure --prefix=/usr/local; make install -j 100 \
    && cd /tmp \
    && pigz -dc rosetta_src_3.13_bundle.tgz | tar xf - \
    && mv /tmp/rosetta_src_2021.16.61629_bundle/main /rosetta \
    && cd /rosetta/source \
    && ./scons.py -j100 bin mode=release extras=mpi \
    && rm -rf /tmp/*
