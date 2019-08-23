FROM image-registry.openshift-image-registry.svc:5000/seafile-dev/rhel7-minimal:1-55

RUN pip install --upgrade pillow \
    numpy==1.16.4 \
    moviepy==0.2.3.5 \
    psycopg2-binary \
    pylibmc \
    django-pylibmc
    
RUN mkdir /app

# add entrypoints
ADD setenv.sh /
ADD docker-entrypoint.sh /

# set environment variables for locale
#ENV LANG=C.UTF-8
#ENV LANGUAGE=C.UTF-8
#ENV LC_ALL=C.UTF-8

# set environment variables for seafile
ENV ROOTPATH=/app
ENV INSTALLPATH=$ROOTPATH/seafile-server-latest
ENV CCNET_CONF_DIR=$ROOTPATH/ccnet
ENV SEAFILE_CENTRAL_CONF_DIR=$ROOTPATH/conf
ENV SEAFILE_CONF_DIR=$ROOTPATH/seafile-data

# setup user environment
VOLUME $SEAFILE_CONF_DIR

RUN wget https://download.seadrive.org/seafile-server_7.0.4_x86-64.tar.gz -O /tmp/seafile-server.tar.gz && \
    tar -C /tmp/ -xzvf /tmp/seafile-server.tar.gz && \
    rm /tmp/seafile-server.tar.gz && \
    mv /tmp/seafile-server-* $INSTALLPATH
RUN rm -rf $INSTALLPATH/seahub/media/avatars
RUN ln -s $ROOTPATH/seahub-data/avatars $INSTALLPATH/seahub/media/avatars

ENTRYPOINT ["/docker-entrypoint.sh"]
