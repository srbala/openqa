#!/bin/bash
# shellcheck disable=SC2012,SC2154
set -e

if [[ -z $qemu_no_kvm ]] || [[ $qemu_no_kvm -eq 0 ]]; then
  if [ -e "/dev/kvm" ] && getent group kvm > /dev/null; then
    kvm=$({ [[ -f /proc/config.gz ]] && test "$(zgrep CONFIG_KVM=y /proc/config.gz)" ; } || true)
    $kvm || lsmod | grep '\<kvm\>' > /dev/null || {
      echo >&2 "KVM module not loaded; QEMU-KVM cannot be used, Software emulation will be used"
      exit 1
    }

    [[ -c /dev/kvm ]] || mknod /dev/kvm c 10 "$(grep '\<kvm\>' /proc/misc | cut -f 1 -d' ')" || {
      echo >&2 "Unable to make /dev/kvm node; QEMU-KVM cannot be used, Software emulation will be used"
      echo >&2 "(This can happen if the container is run without -privileged)"
      exit 1
    }

    group=$(ls -lhn /dev/kvm | cut -d ' ' -f 4)
    groupmod -g "$group" --non-unique kvm
    usermod -a -G kvm _openqa-worker
  else
    echo "Warning: /dev/kvm doesn't exist. If you want to use KVM, run the container with --device=/dev/kvm"
  fi
fi
#
echo >&2 "Calling exec ..."
exec "$@"