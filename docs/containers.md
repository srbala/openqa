# AlmaLinux OpenQA Containers

Creating nodes using container images provides better flexabliy to spin server and worker nodes in minutes. Since the containers created from the images, all nodes are identitical.

AlmaLinux OpenQA test infrastructure based on containers using docker.

!> Working knowledge with docker OR podman is required.

## Requirements

An AlmaLinux 9 system with docker installed. Virtulazion using KVM is installed and configured. Refer to docker or podman doumentation to learn more about them.

## Source details

Following list of folders are available in [`containers`](https://github.com/AlmaLinux/openqa-infra). Each folder has number of `Dockerfiles` for customization and use.

* `base` - Base container, provides foundation for all other openqa containers
* `data` - Data container provides provies the fodler structure layout for container uss.
* `webui` - Container for main server/ui, extends `base` image.
* `worker` - Container for worker node, extends `base` image.

## Building images

Each folder contains Dockerfiles, can be build from the folders.

* `al9_build` - Almalinux 9 images, single arch build script, can be used build all images for single arch.
* `al9_buildx` - Almalinux 9 images, multi arch build script, uses `docker buildx`. Configure `docker buildx` prior to run this script.
* `fedora_build` - Fedora based container images.
* `env_process` - Include funtion script for `build.sh`. Review this script to setup pre-environment variables.
* `build.sh` - All-in-one build script based on param OR environment variable. Review script for usage options.

