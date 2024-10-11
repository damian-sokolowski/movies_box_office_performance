FROM python:3.11-slim

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=0 \
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONPATH=/backend

ENV PACKAGES="\
    apt-utils \
    bash \
    g++ \
    gdal-bin \
    gettext \
    git \
    libev-dev \
    libevdev2 \
    locales \
    make \
    postgresql-client \
    sudo \
    syslinux \
    vim \
    "

RUN mkdir -p /backend

SHELL ["/bin/bash", "-c"]

WORKDIR /backend

RUN apt-get update && \
    apt-get install -y -f --no-install-recommends $PACKAGES

COPY requirements.txt /backend/requirements.txt

RUN pip install -r /backend/requirements.txt

RUN apt-get remove gcc git libaom3 -y && \
    apt-get autoremove --purge -y && \
    apt-get clean && \
    rm -rf /root/.cache/ && \
    rm -rf /usr/src/ && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

COPY backend /backend

RUN dbt deps

COPY docker/docker-entrypoint /docker-entrypoint

ENTRYPOINT ["/docker-entrypoint"]
