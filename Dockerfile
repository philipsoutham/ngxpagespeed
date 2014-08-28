FROM centos:centos7
MAINTAINER Philip Southam <philipsoutham@gmail.com>
ENV NPS_VERSION 1.8.31.4
ENV NGINX_VERSION 1.6.1
RUN yum install openssl-devel tar unzip wget gcc-c++ pcre-dev pcre-devel zlib-devel make -y \
  && yum clean all \
  && cd /tmp \
  && wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip \
  && unzip release-${NPS_VERSION}-beta.zip \
  && cd /tmp/ngx_pagespeed-release-${NPS_VERSION}-beta \
  && wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz \
  && tar -xzvf ${NPS_VERSION}.tar.gz \
  && cd /tmp \
  && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
  && tar -xvzf nginx-${NGINX_VERSION}.tar.gz \
  && cd /tmp/nginx-${NGINX_VERSION} \
  && ./configure --add-module=/tmp/ngx_pagespeed-release-${NPS_VERSION}-beta --sbin-path=/usr/sbin/nginx --with-http_spdy_module --with-http_ssl_module --prefix=/etc/nginx/ \
  && make \
  && make install \
  && cd / \
  && rm -rf nginx-1.6.1  nginx-1.6.1.tar.gz  ngx_pagespeed-release-1.8.31.4-beta  release-1.8.31.4-beta.zip /etc/nginx/sites-enabled/* \
  && mkdir -p /etc/nginx/sites-enabled/

EXPOSE 80
EXPOSE 443

COPY nginx.conf /etc/nginx/conf/nginx.conf
COPY main.sh /

CMD []
ENTRYPOINT ["/main.sh"]
