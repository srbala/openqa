# OpenQA Using Containers

Running AlmaLinux OpenQA in docker/container enviroment.

## System Requirements

AlmaLinux
OpenQA Container Images

## Server configuration

## WebUI

### Set Environment variables

```sh
export OPENQA_BASEDIR=/srv/nfs/openqa
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
       -v ${OPENQA_BASEDIR}/worker/conf/workers.ini:/etc/openqa/workers.ini \
       -v ${OPENQA_BASEDIR}/worker/conf/client.conf:/etc/openqa/client.conf \
       -p 80:80 -p 443:443 -p 9526:9526 -p 9527:9527 -p 9528:9528 -p 9529:9529 \
       --network-alias openqa_webui --name openqa_webui --restart=always \
       almalinux/openqa:webui-al9
```

### Start Worker Node

Local worker node.

```sh
docker run --network aloqa-network \
       --device /dev/kvm --privileged \
       -v ${OPENQA_BASEDIR}/shared/tests:/data/tests \
       -v ${OPENQA_BASEDIR}/shared/factory:/data/factory \
       -v ${OPENQA_BASEDIR}/worker/conf/workers.ini:/etc/openqa/workers.ini \
       -v ${OPENQA_BASEDIR}/worker/conf/client.conf:/etc/openqa/client.conf \
       --restart=always --network-alias openqa_worker1 --name openqa_worker1 -d \
       almalinux/openqa:worker-al9
```

Remote worker node.

```sh
docker run --network aloqa-network \
       --device /dev/kvm --privileged \
       --add-host=openqa_webui:145.40.99.22 \
       -v /mnt/openqa/shared/tests:/data/tests \
       -v /mnt/openqa/shared/factory/iso:/data/factory/iso \
       -v /mnt/openqa/shared/factory/hdd:/data/factory/hdd \
       -v /mnt/openqa/shared/factory/tmp:/data/factory/tmp \
       -v /mnt/openqa/worker/conf/workers.ini:/etc/openqa/workers.ini \
       -v /mnt/openqa/worker/conf/client.conf:/etc/openqa/client.conf \
       --restart=always --network-alias worker1 --name worker1 -d \
       almalinux/openqa:worker-al9
```
