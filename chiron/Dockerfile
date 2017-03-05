FROM anapsix/alpine-java:jre8
MAINTAINER Conor Brennan <brennc27@tcd.ie>

EXPOSE 3030
RUN apk add --no-cache git curl

# Download tdbloader2 binary
ENV JENA_ARCHIVE https://archive.apache.org/dist/
ENV JENA_VERSION 3.2.0
ENV JENA_DIR /opt/jena

RUN mkdir $JENA_DIR && \
    curl $JENA_ARCHIVE/jena/binaries/apache-jena-$JENA_VERSION.tar.gz | tar zxf - -C $JENA_DIR
ENV PATH $JENA_DIR/apache-jena-$JENA_VERSION/bin:$PATH

# Download fuseki-server binary
ENV FUSEKI_VERSION 2.4.0
ENV FUSEKI_DIR /opt/fuseki
ENV FUSEKI_HOME $FUSEKI_DIR/apache-jena-fuseki-$FUSEKI_VERSION

RUN mkdir $FUSEKI_DIR && \
    curl $JENA_ARCHIVE/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz | tar zxf - -C $FUSEKI_DIR
ENV PATH $FUSEKI_DIR/apache-jena-fuseki-$FUSEKI_VERSION:$PATH

# Checkout our chosen version of DINTO
ENV DINTO_DIR /opt/DINTO
ENV DINTO_SHA 68a29b5

WORKDIR $DINTO_DIR
RUN git clone https://github.com/labda/DINTO.git && \
    cd DINTO && \
    git checkout $DINTO_SHA && \
    mv DINTO\ 1/DINTO_1.owl $DINTO_DIR

# Create indexed database from DINTO OWL
RUN SORT_ARGS="-m" tdbloader2 --loc $DINTO_DIR/tdb DINTO_1.owl && rm -rf DINTO DINTO_1.owl



CMD ["fuseki-server", "--loc=/opt/DINTO/tdb", "/dinto"]
