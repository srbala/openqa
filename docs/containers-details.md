# OpenQA Using Containers

Running AlmaLinux OpenQA in docker/container enviroment.

## Server configuration

* AlmaLinux 9 OR a Fedora 37 system
* Server specifications meets the requirements of OpenQA
* AlmaLinux OpenQA Container Images
* Docker installed and configured

## WebUI

### Server Environments

```sh
export OPENQA_BASEDIR=/srv/nfs/openqa
```

Create docker network for containers. Network needs to be created only once on a system.

```sh
docker network create aloqa-network 
```

### Start database

```sh
docker run -d --network aloqa-network --network-alias db --env POSTGRES_PASSWORD=openqa --env POSTGRES_USER=openqa --env POSTGRES_DB=openqa -v ALQA_PGDB:/var/lib/postgresql/data --restart=always --name openqa_db postgres:14
```

### Start WebUI

```sh
docker run -d --network aloqa-network \
       --device /dev/kvm --privileged \
       -v ${OPENQA_BASEDIR}/server/conf/openqa.ini:/etc/openqa/openqa.ini \
       -v ${OPENQA_BASEDIR}/server/conf/database.ini:/etc/openqa/database.ini \
       -v ${OPENQA_BASEDIR}/server/conf/openqa.conf:/etc/httpd/conf.d/openqa.conf \
       -v ${OPENQA_BASEDIR}/server/conf/openqa-ssl.conf:/etc/httpd/conf.d/openqa-ssl.conf \
       -v ${OPENQA_BASEDIR}/server/ssl/certs:/etc/pki/tls/openqa/certs \
       -v ${OPENQA_BASEDIR}/server/ssl/key:/etc/pki/tls/openqa/key \
       -v ${OPENQA_BASEDIR}/server/appdir/testresults:/data/testresults \
       -v ${OPENQA_BASEDIR}/server/appdir/images:/data/images \
       -v ${OPENQA_BASEDIR}/shared/tests:/data/tests \
       -v ${OPENQA_BASEDIR}/shared/factory/iso:/data/factory/iso \
       -v ${OPENQA_BASEDIR}/shared/factory/hdd:/data/factory/hdd \
       -v ${OPENQA_BASEDIR}/shared/factory/tmp:/data/factory/tmp \
       -v ${OPENQA_BASEDIR}/worker/conf/workers.ini:/etc/openqa/workers.ini \
       -v ${OPENQA_BASEDIR}/worker/conf/client.conf:/etc/openqa/client.conf \
       -p 80:80 -p 443:443 -p 9526:9526 -p 9527:9527 -p 9528:9528 -p 9529:9529 \
       --network-alias openqa_webui --name openqa_webui --restart=always \
       almalinux/openqa:webui-al9
```

## Worker Nodes

### Worker Environments

Set the environment variable depends local worker or remote worker.

```sh
export OPENQA_BASEDIR=/srv/nfs/openqa
OR
export RMT_OPENQA_BASEDIR=/mnt/nfs/openqa

```

Create docker network for containers. Network needs to be created only once on a system.

```sh
docker network create aloqa-network 
```

### Local Worker Node

Running a local worker node.

```sh
docker run --network aloqa-network \
       --device /dev/kvm --privileged \
       -v ${OPENQA_BASEDIR}/shared/tests:/data/tests \
       -v ${OPENQA_BASEDIR}/shared/factory/iso:/data/factory/iso \
       -v ${OPENQA_BASEDIR}/shared/factory/hdd:/data/factory/hdd \
       -v ${OPENQA_BASEDIR}/shared/factory/tmp:/data/factory/tmp \
       -v ${OPENQA_BASEDIR}/worker/conf/workers.ini:/etc/openqa/workers.ini \
       -v ${OPENQA_BASEDIR}/worker/conf/client.conf:/etc/openqa/client.conf \
       --restart=always --network-alias openqa_worker1 --name openqa_worker1 -d \
       almalinux/openqa:worker-al9
```

### Remote Worker Node

Running a remote worker node. A NFS server or SSHFS mouts are used to share the data with main web ui server. Pass the additional `add-host` option with fully qualified dns name or IP address for worker to resolve.

```sh
docker run --network aloqa-network \
       --device /dev/kvm --privileged \
       --add-host=openqa_webui:NNN.NNN.NNN.NNN \
       -v ${RMT_OPENQA_BASEDIR}/shared/tests:/data/tests \
       -v ${RMT_OPENQA_BASEDIR}/shared/factory/iso:/data/factory/iso \
       -v ${RMT_OPENQA_BASEDIR}/shared/factory/hdd:/data/factory/hdd \
       -v ${RMT_OPENQA_BASEDIR}/shared/factory/tmp:/data/factory/tmp \
       -v ${RMT_OPENQA_BASEDIR}/worker/conf/workers.ini:/etc/openqa/workers.ini \
       -v ${RMT_OPENQA_BASEDIR}/worker/conf/client.conf:/etc/openqa/client.conf \
       --restart=always --network-alias worker10 --name worker10 -d \
       almalinux/openqa:worker-al9
```
