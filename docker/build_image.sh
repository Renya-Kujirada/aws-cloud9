#!/bin/bash
IMAGE="huggingface-img"

cd $(dirname $0) # change current dir
aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin 763104351884.dkr.ecr.ap-northeast-1.amazonaws.com
docker build -t $IMAGE .
