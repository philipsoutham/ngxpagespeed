#!/bin/bash
OPTIND=1
trap reset SIGTERM

reset() {
    kill -9 $PID
    exit 1
}

function write_head {
    cat > /etc/nginx/sites-enabled/$1 <<EOF
server {
  listen 80;
EOF
}

function write_tail {
    cat >> /etc/nginx/sites-enabled/$1 <<EOF
  root /www/data;

  location / {
    location ~ "\.pagespeed\.([a-z]\.)?[a-z]{2}\.[^.]{10}\.[^.]+" { add_header "" ""; }
    location ~ "^/pagespeed_static/" { }
    location ~ "^/ngx_pagespeed_beacon$" { }
    chunked_transfer_encoding off;
  }
}
EOF
}

function write_server {
    cat >> /etc/nginx/sites-enabled/$1 <<EOF
  server_name $1;
  pagespeed Domain $1;
EOF
}

function write_file {
    write_head $1
    write_server $1
    write_tail $1
}


while getopts "d:" opt; do
    case $opt in
	d) 
	    write_file $OPTARG
	    ;;
    esac
done

ulimit -n 8096
while true; do
    /usr/sbin/nginx -c /etc/nginx/conf/nginx.conf &
    PID=$!
    wait
done
