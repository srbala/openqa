# Advanced Tests

## Kickstart Tests

### Kickstart install - create user

```sh
openqa-cli api --host 'http://localhost' -X POST jobs \
    'ARCH=x86_64' 'ARCH_BASE_MACHINE=64bit' \
    'BACKEND=qemu' \
    VERSION=8.7 \
    BUILD="-install_kickstart_user_creation-$(date +%Y%m%d.%H%M%S).0" \
    'DISTRI=almalinux' 'FLAVOR=dvd-iso' \
    'HDDSIZEGB=14' 'IMAGETYPE=boot' \
    'ISO=AlmaLinux-8.7-x86_64-dvd.iso' \
    'MACHINE=64bit' 'KICKSTART=1' \
    'GRUB=ip=dhcp inst.ks=http://openqa_files/kickstarts/root-user-crypted-net.ks' \
    'PART_TABLE_TYPE=mbr' 'QEMUCPU=Nehalem' \
    'QEMUCPUS=2' 'QEMURAM=3072' 'QEMUVGA=virtio' \
    'QEMU_MAX_MIGRATION_TIME=480' \
    'QEMU_VIRTIO_RNG=1' \
    'SUBVARIANT=dvd-iso' 'TEST=install_kickstart_user_creation' \
    'TEST_SUITE_NAME=install_kickstart_user_creation' \
    'TEST_TARGET=ISO' \
    'WORKER_CLASS=qemu_x86_64' 'XRES=1024' 'YRES=768';
```

```sh
openqa-cli api --host 'http://localhost' -X POST jobs \
    'ARCH=x86_64' 'ARCH_BASE_MACHINE=64bit' \
    'BACKEND=qemu' \
    VERSION=9.1 \
    BUILD="-install_kickstart_firewall_disabled-$(date +%Y%m%d.%H%M%S).0" \
    'DISTRI=almalinux' 'FLAVOR=dvd-iso' \
    'HDDSIZEGB=14' 'IMAGETYPE=boot' \
    'ISO=AlmaLinux-9.1-x86_64-dvd.iso' \
    'MACHINE=64bit' 'KICKSTART=1' \
    'GRUB=ip=dhcp inst.ks=http://openqa_files/kickstarts/firewall-disabled-net.ks' \
    'PART_TABLE_TYPE=mbr' 'QEMUCPU=Nehalem' \
    'QEMUCPUS=2' 'QEMURAM=3072' 'QEMUVGA=virtio' \
    'QEMU_MAX_MIGRATION_TIME=480' \
    'QEMU_VIRTIO_RNG=1' \
    'SUBVARIANT=dvd-iso' 'TEST=install_kickstart_firewall_disabled' \
    'TEST_SUITE_NAME=install_kickstart_firewall_disabled' \
    'TEST_TARGET=ISO' \
    'WORKER_CLASS=qemu_x86_64' 'XRES=1024' 'YRES=768';
```

```sh
openqa-cli api --host 'http://localhost' -X POST jobs \
    'ARCH=x86_64' 'ARCH_BASE_MACHINE=64bit' \
    'BACKEND=qemu' \
    VERSION=9.1 \
    BUILD="-install_kickstart_firewall_configured-$(date +%Y%m%d.%H%M%S).0" \
    'DISTRI=almalinux' 'FLAVOR=boot-iso' \
    'HDDSIZEGB=14' 'IMAGETYPE=boot' \
    'ISO=AlmaLinux-9.1-x86_64-boot.iso' \
    'MACHINE=64bit' 'KICKSTART=1' \
    'GRUB=ip=dhcp inst.ks=http://openqa_files/kickstarts/firewall-configured-net.ks' \
    'PART_TABLE_TYPE=mbr' 'QEMUCPU=Nehalem' \
    'QEMUCPUS=2' 'QEMURAM=3072' 'QEMUVGA=virtio' \
    'QEMU_MAX_MIGRATION_TIME=480' \
    'QEMU_VIRTIO_RNG=1' \
    'SUBVARIANT=boot-iso' 'TEST=install_kickstart_firewall_configured' \
    'TEST_SUITE_NAME=install_kickstart_firewall_configured' \
    'TEST_TARGET=ISO' \
    'WORKER_CLASS=qemu_x86_64' 'XRES=1024' 'YRES=768';
```
