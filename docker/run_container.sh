#!/bin/bash
IMAGE="huggingface-img"
NAME="hf"
WORKSPACE="aws-cloud9"

cd $(dirname $0)
docker run --rm --gpus all --shm-size=32g -v $(pwd)/../..:/app -v $HOME/.aws/:/root/.aws -it --name $NAME -w /app/$WORKSPACE -p 8080:8080 $IMAGE /bin/bash
