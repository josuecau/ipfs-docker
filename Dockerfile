FROM debian:jessie

ARG TZ=Europe/Paris
ARG IPFS_USER=ipfs
ARG IPFS_UID=1000
ARG IPFS_DIR=/home/$IPFS_USER
ARG IPFS_VERSION=v0.4.11
ARG IPFS_ARCHIVE=go-ipfs_${IPFS_VERSION}_linux-amd64.tar.gz

ENV TZ $TZ

RUN apt-get update \
  && apt-get install -y curl \
  && curl -s -o $IPFS_ARCHIVE \
    https://dist.ipfs.io/go-ipfs/${IPFS_VERSION}/${IPFS_ARCHIVE} \
  && tar -zxf $IPFS_ARCHIVE \
  && mv go-ipfs/ipfs /usr/local/bin \
  && chown root:root /usr/local/bin/ipfs \
  && rm -rf go-ipfs $IPFS_ARCHIVE

RUN useradd -m -d $IPFS_DIR -u $IPFS_UID $IPFS_USER

VOLUME $IPFS_DIR

EXPOSE 4001
EXPOSE 4002/udp
EXPOSE 5001
EXPOSE 8080

USER $IPFS_USER
WORKDIR $IPFS_DIR

CMD ipfs daemon --migrate
