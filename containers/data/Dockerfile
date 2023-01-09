FROM almalinux:9
LABEL AUTHOR="Bala Raman <srbala@gmail.com>"
#
# OpenQA data
#

# hadolint ignore=DL3037
RUN dnf install -y ca-certificates git-core && dnf clean all

COPY data.template /data
COPY scripts /scripts
RUN chmod -R 777 /data /scripts
VOLUME ["/data"]

CMD ["/usr/bin/tail", "-f", "dev/null"]
