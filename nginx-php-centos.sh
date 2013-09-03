#!/bin/bash

# =======================================
main() # Main logic
# =======================================
{
    prepare
    install_nginx
}


# =======================================
prepare()
# =======================================
{
    # update yum installer
    sudo yum update --assumeyes
    
    # Install dependencies: Auto-"yes"
    sudo yum install --assumeyes gcc-c++ pcre-dev pcre-devel zlib-devel make
}

# =======================================
get_file()
# =======================================
# $1  source URL
{
    local src="$1"
    
    if [ ! -f ${PS_VER}.zip ]; then
        wget $PS_SRC
    fi
}

# =======================================
install_nginx()
# =======================================
{
    # Install pagespeed and
    local PS_VER=release-1.6.29.5-beta
    local PS_SRC=https://github.com/pagespeed/ngx_pagespeed/archive/${PS_VER}.zip
    local PS_HOME=ngx_${PS_VER}
    local PS_GOOG_VER="1.6.29.5"
    local PS_GOOG_SRC=https://dl.google.com/dl/page-speed/psol/${PS_GOOG_VER}.tar.gz
    local NX_VER="1.4.2"
    local NX_SRC=http://nginx.org/download/nginx-${NX_VER}.tar.gz
    local WORKING_FOLDER=/tmp
    
    # Download ngx_pagespeed
    cd ${WORKING_FOLDER}
    
    if [ ! -f ${PS_VER}.zip ]; then
        wget $PS_SRC
    fi
    
    unzip -n ${PS_VER}.zip
    cd ${PS_HOME}/
    
    # Download pagespeed from Google
    wget $PS_GOOG_SRC
    tar -xzvf ${PS_GOOG_VER}.tar.gz
    
    # Install NginX and bind pagespeed
    cd ${WORKING_FOLDER}
    wget ${NX_SRC}
    tar -xvzf nginx-${NX_VER}.tar.gz
    cd nginx-1.4.2/
    ./configure --add-module=$WORKING_FOLDER/$PS_HOME
    make
    sudo make install
}

# =======================================
# =======================================
# Bootstrap
# =======================================
main > ~/nginx-php-centos-out.log 2> ~/nginx-php-centos-errors.log