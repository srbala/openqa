FROM fedora:37
LABEL AUTHOR="Bala Raman <srbala@gmail.com>"
#
# Base image container for OpenQA 
#
# TODO: Insert test SSL cert in base image for functional testing
#
# Install and configure GOSU
ENV GOSU_VERSION 1.14
RUN set -eux; \
    ARCH="$(arch)"; \
    case "${ARCH}" in \
      aarch64) \
        march="arm64" ; \
        ;; \
      ppc64le) \
        march="ppc64el" ; \
        ;; \
      s390x) \
        march="s390x" ; \
        ;; \         
      x86_64) \
        march="amd64" ; \
        ;; \
      *) \
        echo "Unsupported arch: ${ARCH}"; \
        exit 1; \
        ;; \
    esac; \
    URL="https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${march}" ; \
    curl -o /tmp/gosu -L "${URL}" ;\
    curl -o /tmp/gosu.asc -L "${URL}.asc" ;\
# verify the signature
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /tmp/gosu.asc /tmp/gosu; \
    command -v gpgconf && gpgconf --kill all || :; \
    rm -rf "$GNUPGHOME" /tmp/gosu.asc; \
    chmod +x /tmp/gosu ; \
    mv /tmp/gosu /usr/local/bin/gosu; \
# verify that the binary works
    gosu --version; \
    gosu nobody true; \
    dnf install --nodocs --setopt install_weak_deps=false -y shadow-utils \
      git-core nano catatonit which psmisc nfs-utils iputils postgresql \
      zip xz rsync withlock; \
    dnf clean all ; \
    groupadd -r -g 700 geekotest; \
    groupadd -r -g 701 _openqa-worker; \
    groupadd -r -g 703 qemu; \
    groupadd -r -g 704 libvirt; \
    useradd -r -g 700 -u 700 -c "openQA user" -m -d /var/lib/openqa geekotest; \
    usermod -aG wheel,qemu,libvirt,kvm -v 3100001-3300000 -w 3100001-3300000  geekotest; \
    useradd -r -g 701 -u 701 -c "openQA worker" -m -d /var/lib/empty  _openqa-worker; \
    usermod -aG wheel,qemu,libvirt,kvm -v 3300001-3500000 -w 3300001-3500000 _openqa-worker; \
    echo "geekotest ALL=(ALL)     NOPASSWD: ALL" > /etc/sudoers.d/geekotest ; \
    echo "_openqa-worker ALL=(ALL)     NOPASSWD: ALL" > /etc/sudoers.d/openqawk ; \
    systemctl set-default multi-user.target; \
    ln -sf /usr/libexec/podman/catatonit /usr/local/bin/catatonit ;

# CMD ["/usr/local/bin/run_openqa.sh"]
CMD ["/sbin/init"]