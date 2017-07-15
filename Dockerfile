FROM cmp1234/docker-nginx:1.10.3-python2.7.13-alpine3.6

MAINTAINER Wang Lilong "wanglilong007@gmail.com"

ENV VERSION=10.0.0.0b1

#&& apk add --no-cache libffi-dev python-dev libssl-dev mysql-client python-mysqldb \
		#openssl \
		#openssl-dev \

RUN set -x \  
    && apk add --no-cache --virtual .build-deps \
		coreutils \
		gcc \
		linux-headers \
		make \
		musl-dev \
		zlib \
		zlib-dev \
	mariadb-dev \
    && apk add --no-cache --virtual .run-deps  \
        libffi-dev \
        python-dev \
        mysql-client \
	py-mysqldb \
    && curl -fSL https://github.com/openstack/keystone/archive/${VERSION}.tar.gz -o keystone-${VERSION}.tar.gz \
    && tar xvf keystone-${VERSION}.tar.gz \
    && cd keystone-${VERSION} \
    && pip install -r requirements.txt \
    && PBR_VERSION=${VERSION}  pip install . \
    && pip install uwsgi MySQL-python \
    && cp -r etc /etc/keystone \
    && pip install python-openstackclient \
    && cd - \
    && rm -rf keystone-${VERSION}* \
    && apk del .build-deps
