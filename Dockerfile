FROM centos:centos7
MAINTAINER Philip Southam <philipsoutham@gmail.com>
ENV NPS_VERSION 1.8.31.4
ENV NGINX_VERSION 1.6.1
RUN yum install openssl-devel tar unzip wget gcc-c++ pcre-dev pcre-devel zlib-devel make -y \
  && yum clean all \
  && cd /tmp \
  && wget -q https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip \
  && unzip -q release-${NPS_VERSION}-beta.zip \
  && cd /tmp/ngx_pagespeed-release-${NPS_VERSION}-beta \
  && wget -q https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz \
  && tar -xzf ${NPS_VERSION}.tar.gz \
  && cd /tmp \
  && wget -q http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
  && tar -xzf nginx-${NGINX_VERSION}.tar.gz \
  && cd /tmp/nginx-${NGINX_VERSION} \
  && ./configure --add-module=/tmp/ngx_pagespeed-release-${NPS_VERSION}-beta --sbin-path=/usr/sbin/nginx --with-http_spdy_module --with-http_ssl_module --prefix=/etc/nginx/ \
  && make \
  && make install \
  && cd /tmp \
  && rm -rf nginx-${NGINX_VERSION}  nginx-${NGINX_VERSION}.tar.gz  ngx_pagespeed-release-${NPS_VERSION}-beta  release-${NPS_VERSION}-beta.zip /etc/nginx/sites-enabled/* \
  && cd / \
  && mkdir -p /etc/nginx/sites-enabled/

EXPOSE 80
EXPOSE 443

COPY nginx.conf /etc/nginx/conf/nginx.conf
COPY main.sh /

CMD []
ENTRYPOINT ["/main.sh"]
