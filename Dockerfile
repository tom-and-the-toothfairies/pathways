FROM ubuntu:16.04
MAINTAINER Eoin Houlihan <ehoulih@tcd.ie>

RUN apt-get -qq update && apt-get -qq -y install \
    bison \
    check \
    expect \
    flex \
    git \
    libncurses5-dev \
    libreadline-dev \
    libxml2 \
    python3 \
    python3-venv \
    tcl \
    tcl-dev

COPY . /opt/pathways
WORKDIR /opt/pathways

RUN git submodule update --init --recursive
RUN ./createvirtualenv.sh
RUN cd peos && make

CMD ["./test.sh"]