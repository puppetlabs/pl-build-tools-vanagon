FROM ubuntu:focal

RUN apt-get update
RUN apt-get -y install shellcheck
COPY . /pl-build-tools-vanagon/
CMD /bin/bash -c 'find /pl-build-tools-vanagon/ -type f -name "*.sh"  | xargs shellcheck'
