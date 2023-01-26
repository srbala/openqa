# Almalinux OpenQA  :id=start

AlmaLinux OS testing framework implemented using OpenSUSE OpenQA test framework. This repository contains the necessary install scripts and documentation to set up the OpenQA environment.

## Repos Summary

There are three GitHub repos related to AlmaLinux OpenQA Testing.

* [openqa-infra](https://github.com/AlmaLinux/openqa-infra) -  Contains the install and configuration scripts and essential documentation.
* [os-autoinst-distri-almalinux](https://github.com/AlmaLinux/os-autoinst-distri-almalinux) - OpenQA Test scripts.
* [openqa-createhdds](https://github.com/AlmaLinux/openqa-createhdds) - Utility project to create hard-disk image files for advanced test environments.

## What is OpenQA

openQA is a testing framework that allows you to test GUI applications on one
hand and bootloader and kernel on the other. In both cases, it is difficult to
script tests and verify the output. Output can be a popup window or it can be
an error in early boot even before init is executed.

Therefore openQA runs virtual machines and closely monitors their state and
runs tests on them.

The testing framework can be divided in two parts. The one that is hosted in
this repository contains the web frontend and management logic (test
scheduling, management, high-level API, ...)

The other part that you need to run openQA is the OS-autoinst test engine that
is hosted in a separate [repository](https://github.com/os-autoinst/os-autoinst).

## Setup Requirements

### Software Requirements

Setting up a test environment in a clean/fresh dedicated system is recommended.

* Almaliux 9 system, Fedora 37 can be used as an alternative.
* Internet connection at the time of installation and configuration.
* Docker installed and configured, in case of using a docker/container environment for tests

### Hardware Requirements

The minimum hardware requirements for the host test system to run server UI and one worker node are as follows ...

* 4 core cups
* 8GB RAM
* 64GB HDD
* Internet connection

?> _NOTE:_ Two or more times, the hardware specifications are required to set up advanced tests script environments.

## Next Steps

We have two high level methods to get your AlmaLinux OpenQA test environments ready.

* [Using BMs/VMs](server.md) - Install server and worker node(s) in bare metals or high configuration VM(s) required for this method. Both server and worker are installed and configured to perform tests. Native KVM support is required for better performance.
* [Using docker/podman](containers.md) - Use docker/container images for a quick start. The docker hub already has container images for immediate use. Source container files are also available for any further customizations.

## References

OpenQA Knowledge references:

* OpenQA project website https://open.qa
* os-autoinst https://github.com/os-autoinst/openQA
* OpenQA SUSE https://openqa.opensuse.org/
* OpenSuse test scripts https://github.com/os-autoinst/os-autoinst-distri-opensuse and https://github.com/os-autoinst/os-autoinst-needles-opensuse
* OpenQA Sample test scripts https://github.com/os-autoinst/os-autoinst-distri-example
* OpenQA Fedora https://openqa.fedoraproject.org/
* Fedora direct installation Guide https://fedoraproject.org/wiki/OpenQA_direct_installation_guide
* Fedora test scripts https://git.almalinux.org/srbala/os-autoinst-distri-fedora
* Tutorial create tests Dan Cermak: https://www.youtube.com/watch?v=2zwU9_bV_zI and https://www.youtube.com/watch?v=_JvqVrBjmIU
