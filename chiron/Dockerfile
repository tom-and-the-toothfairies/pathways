FROM anapsix/alpine-java:jre8
MAINTAINER Conor Brennan <brennc27@tcd.ie>

EXPOSE 3030

ENV FUSEKI_VERSION 2.4.0
ENV FUSEKI_ARCHIVE https://archive.apache.org/dist/

RUN apk add --no-cache git curl

ENV FUSEKI_DIR /opt/fuseki
RUN mkdir $FUSEKI_DIR

RUN curl $FUSEKI_ARCHIVE/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz | tar zxf - -C $FUSEKI_DIR

ENV PATH $FUSEKI_DIR/apache-jena-fuseki-$FUSEKI_VERSION:$PATH
ENV FUSEKI_HOME $FUSEKI_DIR/apache-jena-fuseki-$FUSEKI_VERSION

ENV DINTO_DIR /opt/DINTO
WORKDIR $DINTO_DIR
RUN git clone https://github.com/labda/DINTO.git && \
    cd DINTO && \
    git checkout 68a29b5
RUN mv DINTO/DINTO\ 1/DINTO_1.owl . && rm -rf DINTO


CMD ["fuseki-server", "--file=/opt/DINTO/DINTO_1.owl", "/DataPoop"]
