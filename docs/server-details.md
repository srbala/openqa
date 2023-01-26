# Manual Install - Server UI and Worker Node

These steps can be used when Bare Metal(s) or VM(s) are available with native KVM emulation support for OpenQA testing. Make sure to review and run all steps

!> These steps are longer/extracted versions from the predefined scripts. This documentation provides only basic and minimal steps required to get the OpenQA test environment up and running.

?> Most commands require admin privilege to run. Refer to https://open.qa for detailed server customizations.

## Configure packages repo

Install dnf plugin and enable `crb` and `epel`. Both OpenQA server and worker nodes requires this step to get access to necessary packages.

```sh
sudo dnf install -y epel-release 'dnf-command(copr)' 'dnf-command(config-manager)'
sudo dnf -y config-manager --set-enabled crb 
## copr bug, always points to x84_64 repo results error in other arch
# dnf -y copr --hub build.almalinux.org enable eabdullin1/openqa ; \
sudo curl -L https://build.almalinux.org/pulp/content/copr/eabdullin1-openqa-almalinux-9-$(arch)-dr/config.repo -o /etc/yum.repos.d/openqa.repo 
```

## Install OpenQA Server

AlmaLinux version of OpenQA packages available in `eabdullin1/openqa` COPR repo under almalinux. These packages depend on additional packages from `CRB` and `EPEL9` repo. Add `dnf` plugin and enable necessary repos.

### Installing OpenQA

Install the OpenQA packages and additional support packages.

```sh
sudo dnf install -y git-core openqa openqa-httpd postgresql-server \
     root-sql-pgsql mod_ssl perl-REST-Client python3-jsonschema \
     perl-Mojolicious-Plugin-OAuth2 python3-pip openqa-python-scripts \
     nano which psmisc nfs-utils iputils zip xz rsync withlock
```

?> Some packages above are optional. Some may be required to be installed in the post-install process. For example `perl-Mojolicious-Plugin-OAuth2` only required for `OAuth2` integration. Packages `nano, which, psmisc, nfs-utils, iputils` are helpers for analysis.

### Configure HTTPD

After the successful installation of all packages, configure the httpd service. Customize the primary site from the existing template.

```sh
  sudo cp /etc/httpd/conf.d/openqa.conf.template /etc/httpd/conf.d/openqa.conf
```

!> Make necessary changes SSL config, if the site needs to be accessed thru HTTPS. 

?> _NOTE:_ You can skip the SSL config if you plan to use it for local development/debug purposes only.

```sh
sudo cp /etc/openqa/openqa.ini /etc/openqa/openqa.ini.orig
sudo bash -c "cat >/etc/openqa/openqa.ini <<'EOF'
[global]
branding=plain
download_domains = almalinux.org docs.openqa.almalinux.org fedoraproject.org opensuse.org almalinux.github.io
recognized_referers = bugs.almalinux.org git.almalinux.org almalinux.org bugzilla.suse.com bugzilla.opensuse.org progress.opensuse.org github.com gitlab.com

[auth]
method = Fake
EOF"
```

!> _TIP:_ Use `Fake` auth method for development purposes only. OpenQA supports `OpenID` and `OAuth2` integrations. Refer to https://open.qa for detailed server customizations.


### Start database and SSH services

Initilize the `postgresql` database and start the service. Also start `sshd` service.

```sh
sudo postgresql-setup --initdb
sudo systemctl enable --now postgresql
sudo systemctl start --now sshd
```

### Start OpenQA services


```sh
sudo systemctl enable --now openqa-scheduler
sudo systemctl enable --now openqa-gru
sudo systemctl enable --now openqa-websockets
sudo systemctl enable --now openqa-webui
sudo systemctl enable --now openqa-livehandler
sudo systemctl enable --now httpd
sudo setsebool -P httpd_can_network_connect 1
sudo systemctl restart httpd
```

Configure firewall and restart service.

```sh
sudo firewall-cmd --zone=public --permanent --add-service=http
sudo firewall-cmd --zone=public --permanent --add-service=https
sudo firewall-cmd --reload
```

### Next steps

The basic server setup is complete now. Server Web UI available at `http://$(hostname -f)/`.

!>  _NOTE:_ Access server web ui, log in to admin console, and generate API keys for client and worker configurations.

?> Proceed to OpenQA Worker install next.

## Install OpenQA Worker

AlmaLinux version of OpenQA packages available in `eabdullin1/openqa` COPR repo under almalinux. These packages depend on additional packages from `CRB` and `EPEL9` repo. Add `dnf` plugin and enable necessary repos.

### Set `hostname`

Setup hostname for scripts use. Usually fully qualified DNS name or a name by which server can be accessed thru netowrk. It can be defaulted to `localhost always.

```sh
QAHOST="localhost"
```

### Identify QEMU package

Identify QEMU system package depends on the base OS `arch` information. In most cases  it would be `qemu-system-x86`.

```sh
ARCH="$(arch)"
case "${ARCH}" in 
    aarch64) qemu_pkg="qemu-system-aarch64"; 
    ;; 
    ppc64le) qemu_pkg="qemu-system-ppc"; 
    ;; 
    s390x) qemu_pkg="qemu-system-s390x"; 
    ;; 
    x86_64) qemu_pkg="qemu-system-x86"; 
    ;; 
    *) 
    echo "Unsupported arch: ${ARCH}"; 
    exit 1; 
    ;; 
esac;
```

?> New Intel and AMD processors support secondary-level virtualization support. Now any arch environments can be emulated on Bare metal systems.

### Install Worker packages

```sh
sudo dnf install -y --setopt install_weak_deps=false \
    --nodocs openqa-worker perl-REST-Client $qemu_pkg \
    os-autoinst-openvswitch python3-openvswitch \
    openvswitch-ipsec openvswitch-dpdk \
    qemu-tools qemu-img qemu-pr-helper ipxe-roms-qemu \
    which psmisc nfs-utils iputils rsync withlock \
    --exclude qemu-kvm-7.0.0;
```

### Update firewall configuration

Command below open vnc ports for 10 local worker clients. Also adds new service "isotovideo" with ports covering 10 worker slots for debugging. Adds both services to public zone and makes it available for immediate use.

```sh
sudo firewall-cmd --permanent --new-service=openqa-vnc
sudo firewall-cmd --permanent --service=openqa-vnc --add-port=5900-5999/tcp
sudo firewall-cmd --zone=public --permanent --add-service openqa-vnc
sudo firewall-cmd --permanent --new-service isotovideo
for i in {1..10}; do sudo firewall-cmd --permanent --service=isotovideo --add-port=$((i * 10 + 20003))/tcp ; done
sudo firewall-cmd --zone=public --permanent --add-service=isotovideo
sudo firewall-cmd --reload
```

### Client configuration

Worker node client configuration. Configure server API key for worker connection and further API calls.

```sh
sudo mv /etc/openqa/client.conf /etc/openqa/client.conf_orig
sudo bash -c "cat >/etc/openqa/client.conf <<'EOF'
[$QAHOST]
key = 1234567890ABCDEF
secret = 1234567890ABCDEF
EOF"
```

!> _NOTE:_ `Fake` auth generates temporary `key/secret (1234567890ABCDEF)` expires in 24 hours. Update with the correct keys. Use web admin ui to generate new keys.

```sh
sudo mv /etc/openqa/workers.ini /etc/openqa/workers.ini_orig
sudo bash -c "cat >/etc/openqa/workers.ini <<'EOF'
[global]
HOST = http://$QAHOST
EOF"
```

```sh
  sudo systemctl enable --now openqa-worker@1.service
```

?> Proceed next to install/import and configure almalinux openqa tests, jobs, and scripts.

## Install AlmaLinux tests

The server web ui and worker is installed and configured, proceed to import and test almalinux openqa test scripts.

1. Clone project
   * Clone repo
   * Update folder owner access to OpenQA test user
   * Checkout to a fix branch as needed
2. Import project into OpenQA
3. Download required ISO to test
4. Use OpenQA-Cli to invoke test

!> Large repo size warning! Due to this project's nature, it might take some time to clone it. Adjust the clone step as needed. For example, add `--depth=1` for shallow copy and quick test. Switch to a new branch for a new test.

### Step 1

Step 1: Clone repo, update folder owner to openqa test user.

```sh
cd /var/lib/openqa/tests/
sudo git clone --single-branch --branch=dev https://github.com/AlmaLinux/os-autoinst-distri-almalinux.git almalinux
sudo chown -R geekotest:geekotest almalinux
cd almalinux
git config --global --add safe.directory /var/lib/openqa/share/tests/almalinux
sudo git checkout -b testNNN
```

### Step 2

Step 2: import almalinux test templates.

```sh
cd /var/lib/openqa/tests/almalinux 
sudo ./fifloader.py -l -c templates.fif.json templates-updates.fif.json
```

### Step 3

Download one or more AlmaLinux ISOs from repo and perform some basic testing.

```sh
sudo mkdir -p /var/lib/openqa/share/factory/iso/fixed
cd /var/lib/openqa/share/factory/iso/fixed
  sudo curl -C - -O https://repo.almalinux.org/almalinux/9/isos/x86_64/AlmaLinux-9.1-x86_64-boot.iso
  sudo curl -C - -O https://repo.almalinux.org/almalinux/9/isos/x86_64/AlmaLinux-9.1-x86_64-minimal.iso 
  sudo curl -C - -O https://repo.almalinux.org/almalinux/9/isos/x86_64/AlmaLinux-9.1-x86_64-dvd.iso 
  sudo curl -C - -O https://repo.almalinux.org/almalinux/9/isos/x86_64/CHECKSUM
  shasum -a 256 --ignore-missing -c CHECKSUM
```

?> _TIP:_ Single ISO file is enough to start the testing. Choose one based on your test case.

### Step 4

In this step we
Make adjustment based downloaded ISO file and `FLAVOR` variable name. Possible values are `boot-iso`, `dvd-iso`, and `minimal-iso`, based on ISO variants available.

```sh
sudo openqa-cli api -X POST isos \
  ISO=AlmaLinux-9.1-x86_64-boot.iso \
  ARCH=x86_64 \
  DISTRI=almalinux \
  FLAVOR=boot-iso \
  VERSION=9.1 \
  BUILD="-boot-$(date +%Y%m%d.%H%M%S).0"
```

Access the server web ui to review posted jobs and their details.

?> OpenQA-CLI commands helps to query the jobs using APIs.

```sh
openqa-cli api -X GET --pretty jobs/overview
openqa-cli api -X GET --pretty jobs/1
```
