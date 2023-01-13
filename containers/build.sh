#!/bin/bash
#
source env_process
#
cd base ; docker build -t "$OPENQA_IMAGE_BASE" -f "$FILE_NAME" .
cd ../webui ; docker build --build-arg SYSBASE=$OPENQA_IMAGE_BASE -t "$OPENQA_IMAGE_WEBUI" -f "$FILE_NAME" .
cd ../worker ; docker build --build-arg SYSBASE=$OPENQA_IMAGE_BASE -t "$OPENQA_IMAGE_WORKER" -f "$FILE_NAME" .
cd ..
