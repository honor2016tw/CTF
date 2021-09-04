#!/bin/sh
docker build --no-cache -t pwn .

docker run -it --rm --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v `pwd`:/tmp/host -w /root pwn

