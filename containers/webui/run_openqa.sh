#!/bin/bash
set -e

function wait_for_db_creation() {
  echo "Waiting for DB creation"
  while ! gosu geekotest -c 'PGPASSWORD=openqa psql -h db -U openqa --list | grep -qe openqa'; do sleep .1; done
}

function upgradedb() {
  wait_for_db_creation
  gosu geekotest -c '/usr/share/openqa/script/upgradedb --upgrade_database'
}

function scheduler() {
  gosu geekotest -c /usr/share/openqa/script/openqa-scheduler-daemon
}

function websockets() {
  gosu geekotest -c /usr/share/openqa/script/openqa-websockets-daemon
}

function gru() {
  wait_for_db_creation
  gosu geekotest -c /usr/share/openqa/script/openqa-gru
}

function livehandler() {
  wait_for_db_creation
  gosu geekotest -c /usr/share/openqa/script/openqa-livehandler-daemon
}

function webui() {
  wait_for_db_creation
  gosu geekotest -c /usr/share/openqa/script/openqa-webui-daemon
}

function all_together_apache() {
  # run services
  gosu geekotest -c /usr/share/openqa/script/openqa-scheduler-daemon &
  gosu geekotest -c /usr/share/openqa/script/openqa-websockets-daemon &
  gosu geekotest -c /usr/share/openqa/script/openqa-gru &
  gosu geekotest -c /usr/share/openqa/script/openqa-livehandler-daemon &
#  apache2ctl start
  rm -rf /run/httpd/* /tmp/httpd*
  exec /usr/sbin/httpd -D FOREGROUND  
  gosu geekotest -c /usr/share/openqa/script/openqa-webui-daemon
}

## Change shell? 
# usermod --shell /bin/sh geekotest

# if `docker run` first argument start with `--` the user is passing openqa launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]] || [[ -n "$MODE" ]]; then
# run services
  case "$MODE" in
    upgradedb ) upgradedb;;
    scheduler ) scheduler;;
    websockets ) websockets;;
    gru ) gru;;
    livehandler ) livehandler;;
    webui ) webui;;
    * ) all_together_apache;;
  esac
fi

# As argument is not openqa, assume user wants to run a different process, for example a `bash` shell to explore this image
exec "$@"