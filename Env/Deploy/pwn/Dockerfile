FROM ubuntu
RUN apt-get update
RUN apt-get install xinetd -y
RUN apt-get install libc6-dev-i386 -y
RUN useradd -m pwn
RUN chown -R root:root /home/pwn
CMD ["/usr/sbin/xinetd","-dontfork"]
