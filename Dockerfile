FROM fedora:21
MAINTAINER Philip Southam <philip@eml.cc>
ENV NPS_VERSION 1.9.32.2
ENV NGINX_VERSION 1.6.2
RUN yum install openssl-devel tar unzip gcc-c++ pcre-dev pcre-devel zlib-devel make -y \
  && cd /tmp \
  && curl --remote-name --location --silent https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip \
  && unzip -q release-${NPS_VERSION}-beta.zip \
  && cd /tmp/ngx_pagespeed-release-${NPS_VERSION}-beta \
  && curl --remote-name --location --silent https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz \
  && tar --no-same-owner -xzf ${NPS_VERSION}.tar.gz \
  && cd /tmp \
  && curl --remote-name --location --silent http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
  && tar --no-same-owner -xzf nginx-${NGINX_VERSION}.tar.gz \
  && cd /tmp/nginx-${NGINX_VERSION} \
  && ./configure --add-module=/tmp/ngx_pagespeed-release-${NPS_VERSION}-beta --sbin-path=/usr/sbin/nginx --with-http_spdy_module --with-http_ssl_module --prefix=/etc/nginx\
  && make \
  && make install \
  && yum remove binutils cpp dracut mpfr openssl-devel tar unzip gcc-c++ pcre-dev pcre-devel zlib-devel make *-devel *-headers -y\
  && yum autoremove -y\
  && cd /tmp \
  && rm -rf nginx-${NGINX_VERSION}  nginx-${NGINX_VERSION}.tar.gz  ngx_pagespeed-release-${NPS_VERSION}-beta  release-${NPS_VERSION}-beta.zip /etc/nginx/sites-enabled/* /var/cache/yum \
  && cd / \
  && mkdir -p /etc/nginx/sites-enabled/\
  && chown nobody:nobody /etc/nginx/sites-enabled

EXPOSE 80
#EXPOSE 443

COPY nginx.conf /etc/nginx/conf/nginx.conf
COPY main.sh /

CMD ["-d", "localhost"]
ENTRYPOINT ["/main.sh"]

