from ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
run sed -i 's/archive.ubuntu.com/free.nchc.org.tw/g' /etc/apt/sources.list 
add setup.sh /tmp/
add packagelist /tmp/
run sh /tmp/setup.sh

cmd bash -i
