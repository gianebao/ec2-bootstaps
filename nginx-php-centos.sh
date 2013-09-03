#!/bin/bash

set -e

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
    local SRC="$1"
    local BASE=${SRC##*/}
    
    if [ ! -f $BASE ]; then
        wget $SRC
    fi
    
    echo $BASE
}

# =======================================
install_nginx()
# =======================================
{
    # Install pagespeed and
    local PS_VER=release-1.6.29.5-beta
    local PS_GOOG_VER="1.6.29.5"
    local NX_VER="1.4.2"
    
    local PS_SRC=https://github.com/pagespeed/ngx_pagespeed/archive/${PS_VER}.zip
    local PS_HOME=ngx_pagespeed-${PS_VER}
    local PS_GOOG_SRC=https://dl.google.com/dl/page-speed/psol/${PS_GOOG_VER}.tar.gz
    local NX_SRC=http://nginx.org/download/nginx-${NX_VER}.tar.gz
    local WORKING_FOLDER=/tmp
    
    cd $WORKING_FOLDER
    
    # Download ngx_pagespeed
    unzip -n `get_file $PS_SRC`
    cd $PS_HOME/
    
    # Download pagespeed from Google
    tar -xzvf `get_file $PS_GOOG_SRC`
    
    cd $WORKING_FOLDER
    
    # Install NginX and bind pagespeed
    tar -xvzf `get_file $NX_SRC`
    cd nginx-${NX_VER}/
    
    # Configure NginX
    ./configure --add-module=$WORKING_FOLDER/$PS_HOME \
        --sbin-path=/usr/sbin \
        --conf-path=/etc/nginx
    
    # Fire it up!
    make
    sudo make install
}

# =======================================
# =======================================
# Bootstrap
# =======================================

CURRENT_DIR=$(pwd)
main > ~/nginx-php-centos-out.log 2> ~/nginx-php-centos-errors.log
cd $CURRENT_DIR