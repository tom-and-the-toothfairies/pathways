FROM anapsix/alpine-java:jre8
MAINTAINER Conor Brennan <brennc27@tcd.ie>

EXPOSE 3030

ENV JENA_VERSION 3.2.0
ENV FUSEKI_VERSION 2.4.0
ENV FUSEKI_ARCHIVE https://archive.apache.org/dist/

RUN apk add --no-cache git curl

ENV FUSEKI_DIR /opt/fuseki
ENV JENA_DIR /opt/jena
RUN mkdir $FUSEKI_DIR && mkdir $JENA_DIR

RUN curl $FUSEKI_ARCHIVE/jena/binaries/apache-jena-$JENA_VERSION.tar.gz | tar zxf - -C $JENA_DIR
RUN curl $FUSEKI_ARCHIVE/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz | tar zxf - -C $FUSEKI_DIR

ENV PATH $JENA_DIR/apache-jena-$JENA_VERSION/bin:$PATH
ENV PATH $FUSEKI_DIR/apache-jena-fuseki-$FUSEKI_VERSION:$PATH
ENV FUSEKI_HOME $FUSEKI_DIR/apache-jena-fuseki-$FUSEKI_VERSION

ENV DINTO_DIR /opt/DINTO
WORKDIR $DINTO_DIR
RUN git clone https://github.com/labda/DINTO.git && \
    cd DINTO && \
    git checkout 68a29b5 && \
    mv DINTO\ 1/DINTO_1.owl $DINTO_DIR
RUN SORT_ARGS="-m" tdbloader2 --loc $DINTO_DIR/tdb DINTO_1.owl && rm -rf DINTO DINTO_1.owl



CMD ["fuseki-server", "--loc=/opt/DINTO/tdb", "/DataPoop"]
