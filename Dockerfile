FROM ubuntu:22.04

RUN apt update && \
  apt install wget -y && \
  wget -O PPL.deb https://dl4jz3rbrsfum.cloudfront.net/software/PPL_64bit_v1.4.1.deb && \
  dpkg -i PPL.deb && \
  apt clean && \
  rm -rf /var/lib/apt/lists/*

COPY bin/pwrstat-exporter /app/pwrstat-exporter
COPY scripts/init.sh /app
RUN chmod +x /app/init.sh

ENTRYPOINT ["/app/init.sh"]
