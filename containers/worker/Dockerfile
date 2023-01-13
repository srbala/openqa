ARG SYSBASE=srbala/openqa:base-al9
FROM ${SYSBASE}
LABEL author Bala Raman <srbala@gmail.com>
#
# OpenQA Worker Node Image
#
RUN set -eux; \
    dnf install -y https://build.almalinux.org/pulp/content/copr/eabdullin1-openqa-almalinux-9-ppc64le-dr/Packages/s/SLOF-20210217-1.el9.noarch.rpm ; \
    dnf install -y https://repo.almalinux.org/almalinux/9/AppStream/aarch64/os/Packages/edk2-aarch64-20220526git16779ede2d36-3.el9.noarch.rpm ;\
    ARCH="$(arch)"; \
    case "${ARCH}" in \
      aarch64) \
        march="arm64" ; qarch="aarch64"; \
        optstr="qemu-system-aarch64"; \
        ;; \
      ppc64le) \
        march="ppc64el" ; qarch="ppc"; \
        optstr="qemu-system-ppc"; \
        ;; \
      s390x) \
        march="s390x" ; qarch="s390x"; \
        optstr="qemu-system-s390x"; \
        ;; \         
      x86_64) \
        march="amd64" ; qarch="x86"; \
        optstr=" qemu-system-aarch64 qemu-system-ppc qemu-system-x86 qemu-system-s390x"; \
        ;; \
      *) \
        echo "Unsupported arch: ${ARCH}"; \
        exit 1; \
        ;; \
    esac; \
#    dnf install -y --setopt install_weak_deps=false --nodocs openqa-worker perl-REST-Client qemu-kvm-tools qemu-img qemu-pr-helper ipxe-roms-qemu qemu-kvm-7.0.0; \
    dnf install -y --nodocs --setopt install_weak_deps=false \
      openqa-worker \
      ${optstr} \
      qemu-tools \
      qemu-img \
      qemu-pr-helper \
      ipxe-roms-qemu\
      perl-REST-Client \
      os-autoinst-openvswitch \
      python3-openvswitch \
      openvswitch-ipsec \
      openvswitch-dpdk \
      qemu-virtiofsd \
      qemu-device-* \
      qemu-ui-* \
      qemu-user* \
      libvirt-daemon-driver-qemu \
      qemu-guest-agent \
      --exclude qemu-kvm-7.0.0; \
    dnf clean all; \
    mkdir -p /root/qemu

COPY kvm-mknod.sh /root/qemu/kvm-mknod.sh
COPY run_openqa_worker.sh /run_openqa_worker.sh
# ensure executability in case we loose file permissions, e.g. within open
# build service when downloading files into the container build project
RUN chmod +x /root/qemu/kvm-mknod.sh && \
    chmod a+x /run_openqa_worker.sh && \
    # set-up shared data and configuration
    mkdir -p /data/factory /data/tests /data/conf && \
    rm -rf /etc/openqa/client.conf /etc/openqa/workers.ini && \
    mkdir -p /var/lib/openqa/share && \
    ln -s /data/factory /var/lib/openqa/share/factory && \
    ln -s /data/tests /var/lib/openqa/share/tests && \
    # set proper ownership and file modes
    chown -h geekotest /var/lib/openqa/share/* && \
    chown -R _openqa-worker /usr/share/openqa/script/worker /var/lib/openqa/cache /var/lib/openqa/pool && \
    chmod -R ug+rw /usr/share/openqa/script/worker /var/lib/openqa/cache /var/lib/openqa/pool && \
    find /usr/share/openqa/script/worker /var/lib/openqa/cache /var/lib/openqa/pool -type d -exec chmod ug+x {} \;

ENTRYPOINT [ "/usr/libexec/catatonit/catatonit" ]
CMD ["/run_openqa_worker.sh"]
# CMD [ "/bin/bash" ]