#!/bin/bash
# ------------------------------------------------------------------
# [Boris Mihajlovski] Build/Run docker container for react app
# ------------------------------------------------------------------

SUBJECT=16cd4c6c-7a10-11eb-9439-0242ac130002

# --- Locks -------------------------------------------------------
LOCK_FILE=/tmp/$SUBJECT.lock
if [ -f "$LOCK_FILE" ]; then
    echo "$(basename $0)" " is already running"
    exit
fi

trap "rm -f $LOCK_FILE" EXIT
touch $LOCK_FILE

# --- Body --------------------------------------------------------

# Update the base image
docker pull node:14.15.1-stretch-slim

docker build --force-rm -t wildfire-tracker-demo -f Dockerfile .

docker run --rm -it --name=wildfire-tracker-demo \
    -v "$(pwd)":/project --mount source=wildfire-tracker-demo,target=/project/app/node_modules \
    -v /tmp:/tmp --hostname wildfire-tracker-demo \
    -p 3000:3000 \
    wildfire-tracker-demo tmux -L wildfire-tracker-demo

DANGLING=$(docker images -f "dangling=true" -q)
if [ "x""$DANGLING" != "x" ]; then
    docker rmi $DANGLING
fi

echo "Successfuly destroyed all linked containers"

exit 0