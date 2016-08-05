FROM lsiobase/alpine
MAINTAINER sparklyballs

# install packages
RUN \
 apk add --no-cache \
	acl \
	bzip2 \
	curl \
	git \
	gzip \
	nano \
	nginx \
	openssl \
	patch \
	php5-apcu \
	php5-bz2 \
	php5-cli \
	php5-curl \
	php5-dba \
	php5-dev \
	php5-exif \
	php5-fpm \
	php5-gd \
	php5-iconv \
	php5-imap \
	php5-intl \
	php5-json \
	php5-ldap \
	php5-mcrypt \
	php5-openssl \
	php5-pdo_mysql \
	php5-pdo_pgsql \
	php5-pear \
	php5-pspell \
	php5-shmop \
	php5-snmp \
	php5-soap \
	php5-sockets \
	php5-sqlite3 \
	php5-sysvmsg \
	php5-sysvsem \
	php5-sysvshm \
	php5-xml \
	php5-xmlreader \
	php5-xmlrpc \
	php5-zip \
	php5-zlib \
	rsync \
	sqlite \
	sqlite-dev \
	ssmtp \
	subversion \
	tar \
	unzip \
	wget \
	zip

# install pear packages
RUN \
 pear channel-update \
	pear.php.net && \
 pear upgrade PEAR && \
 pear install \
	HTTP_WebDAV_Client && \
 pear install \
	Mail_mimeDecode && \
 pear install \
	'channel://pear.php.net/HTTP_OAuth-0.2.3' && \
 pear install \
	'channel://pear.php.net/VersionControl_Git-0.4.4'

# configure sstmp and php
RUN \
 rm \
	/etc/ssmtp/ssmtp.conf && \
 mv \
	/usr/sbin/sendmail /usr/sbin/sendmail.org && \
 ln -s \
	/usr/sbin/ssmtp /usr/sbin/sendmail && \
sed -i \
		-e "s@\output_buffering =.*@\output_buffering = \off@g" \
		-e "s/upload_max_filesize =.*$/upload_max_filesize = 2048M/" \
		-e "s/post_max_size =.*$/post_max_size = 1560M/" \
		-e 's#;session.save_path = "/tmp"#session.save_path = "/tmp"#g' \
	/etc/php5/php.ini

# add local files
COPY root/ /

# ports and volumes
EXPOSE 443
VOLUME /config /data
