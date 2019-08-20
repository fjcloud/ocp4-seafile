FROM ubuntu:16.04

RUN apt update && apt install -y \
    python \
    python2.7 \
    libpython2.7 \
    python-setuptools \
    python-imaging \
    python-ldap \
    python-urllib3 \
    python-pip \
    python-memcache \
    ffmpeg \
    libmemcached-dev \
    build-essential \
    python-dev \
    zlib1g-dev \
    wget
RUN pip2 install --upgrade pip && \
    pip2 install --upgrade wheel && \
    pip2 install --upgrade pillow \
    numpy==1.16.4 \
    moviepy==0.2.3.5 \
    psycopg2-binary \
    pylibmc \
    django-pylibmc

# add entrypoints
ADD setenv.sh /
ADD docker-entrypoint.sh /

# set environment variables for locale
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8
ENV LC_ALL=C.UTF-8

# set environment variables for seafile
ENV ROOTPATH=/haiwen
ENV INSTALLPATH=$ROOTPATH/seafile-server-latest
ENV CCNET_CONF_DIR=$ROOTPATH/ccnet
ENV SEAFILE_CENTRAL_CONF_DIR=$ROOTPATH/conf
ENV SEAFILE_CONF_DIR=$ROOTPATH/seafile-data

# setup user environment
RUN addgroup --gid 1000 seafile && \
    adduser --gid 1000 --uid 1000 --system --shell /bin/bash --home $ROOTPATH seafile
USER seafile
VOLUME $SEAFILE_CONF_DIR

RUN wget https://download.seadrive.org/seafile-server_7.0.4_x86-64.tar.gz -O /tmp/seafile-server.tar.gz && \
    tar -C /tmp/ -xzvf /tmp/seafile-server.tar.gz && \
    rm /tmp/seafile-server.tar.gz && \
    mv /tmp/seafile-server-* $INSTALLPATH
RUN rm -rf $INSTALLPATH/seahub/media/avatars
RUN ln -s $ROOTPATH/seahub-data/avatars $INSTALLPATH/seahub/media/avatars

ENTRYPOINT ["/docker-entrypoint.sh"]
