FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.13

ARG BUILD_DATE
ARG VERSION
ARG GRAV_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="TheSpad"

RUN \
  apk add --update --no-cache \
    curl \
    composer \
    php7-dom \
    php7-gd \
    php7-tokenizer \
    php7-opcache \
    php7-pecl-apcu \
    php7-pecl-yaml \
    unzip && \
  if [ -z ${GRAV_RELEASE+x} ]; then \
    GRAV_RELEASE=$(curl -sX GET "https://api.github.com/repos/getgrav/grav/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  echo "*** Installing Grav ***" && \
  curl -o \
    /tmp/grav.zip -L \
    "https://github.com/getgrav/grav/releases/download/${GRAV_RELEASE}/grav-admin-v${GRAV_RELEASE}.zip" && \
  unzip -q \
    /tmp/grav.zip -d /app && \
  echo "*** Cleaning Up ***" && \
  rm /tmp/grav.zip

COPY root/ /

EXPOSE 80

VOLUME /config