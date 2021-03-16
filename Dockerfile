FROM ubuntu:focal

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    supervisor \
    wget \
    ca-certificates

# create user
RUN set -eux; \
groupadd -r testuser --gid=999; \
useradd -r -g testuser --uid=999 --shell=/bin/bash testuser;

# get nuclei
RUN wget https://github.com/projectdiscovery/nuclei/releases/download/v2.3.0/nuclei_2.3.0_linux_arm64.tar.gz
RUN tar -xzf nuclei*.tar.gz
RUN mv nuclei /usr/local/bin/

# update and move/chown the templates
RUN nuclei -update-templates
RUN mkdir -p /opt/test
RUN mv /root/nuclei-templates /opt/test
RUN chown -R testuser:testuser /opt
RUN nuclei -version

# copy the test binary and supervisor conf
COPY test.conf /etc/supervisor/conf.d
COPY test /

CMD ["/usr/bin/supervisord", "-n"]
