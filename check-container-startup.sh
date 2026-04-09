#!/bin/bash

echo "Checking container starts correctly: $1"
image_name=`podman run -d -p 9300:9300 $1`

result="1"
count="0"
until [ $result -eq 0 ] || [ $count -gt 10 ] ; do
  curl "127.0.0.1:9300/v2/ping"
  result=$?
  sleep 1
  ((count++))
done

podman stop $image_name && podman rm $image_name

echo "Finished testing container startup. Exit code: $result"

exit $result