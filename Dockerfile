# Rosetta2Go
# https://github.com/Metaphorme/Rosetta2Go
# MIT License
# Copyright (c) 2022 Metaphorme <https://github.com/Metaphorme>

LABEL org.opencontainers.image.authors="Metaphorme"
LABEL org.opencontainers.image.documentation="https://github.com/Metaphorme/Rosetta2Go"

FROM debian:bullseye

ARG DEBIAN_FRONTEND=noninteractive

ENV PATH=/rosetta/source/bin:$PATH
    LIB_LIBRARY_PATH=/rosetta/source/external/lib:$LIB_LIBRARY_PATH

COPY rosetta_src_3.13_bundle.tgz /tmp

VOLUME /data

RUN set -x; DEBIAN_FRONTEND=noninteractive \
    && buildDeps='build-essential python3 pigz openmpi-bin libopenmpi-dev vim nano' \
    && sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && apt-get update; apt-get install -y $buildDeps \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && cd /tmp; tar --use-compress-program=pigz -xvpf rosetta_src_3.13_bundle.tgz \
    && mv rosetta_src_2021.16.61629_bundle/main /rosetta \
    && cd /rosetta/source \
    && ./scons.py -j100 bin mode=release extras=mpi \
    && mkdir /data \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* \
    && apt-get clean
