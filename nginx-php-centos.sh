#!/bin/bash
# @Disclaimer  This is an open-source product. THE OWNER WILL NOT PROVIDE ANY WARANTY OR GUARANTEE
# This script will setup a [Linux Centos] OS with:
#   - NginX with modules:
#       HTTP SSL
#       Google Pagespeed
#   - Git
#   - PHP-FPM
#   - PHP with modules: [To add more modules, execute it separately]
#      apc
#      gd
#      xml
#      curl
#      json
#      pear
#      c++
#      imap
#      mcrypt


set -e

TMPFLDR=/tmp

# =======================================
main() # Main logic
# =======================================
{
    
    local PS_VER="1.6.29.5" # Google Pagespeed version
    local NX_VER="1.5.4"    # NginX version
    
    prepare
    install_nginx -n $NX_VER -p $PS_VER
    
    sudo yum install --assumeyes /
        git /
        php54 /
        php54-fpm /
        php54-apc /
        php54-curl /
        php54-gd /
        php54-imap /
        php54-json /
        php54-mcrypt/ 
        php-pear /
        php54-xml
    
    cleanup
}


# =======================================
prepare() # Prepares the system for the installation
# =======================================
{
    # update yum installer
    sudo yum update --assumeyes
    
    # Install dependencies: Auto-"yes"
    sudo yum install --assumeyes gcc-c++ pcre-dev pcre-devel zlib-devel make
}

# =======================================
cleanup() # Cleanup all files
# =======================================
{
    rm -rf $TMPFLDR/*
}

# =======================================
install_nginx() # Install NginX
# Features:
# Google Pagespeed
# HTTP SSL
# =======================================
# -n  NginX version
# -p  Pagespeed version
{
    local PS_VER="1.6.29.5"
    local NX_VER="1.5.4"

    while getopts ":n:p:" option; do
        case $option in
            p)
                # Pagespeed version
                PS_VER="$OPTARG"
            ;;
            n)
                #NginX version
                NX_VER="$OPTARG"
            ;;
            :)
                echo "Error: -$OPTARG requires an argument"
                exit 1
            ;;
            \?)
                echo "Error: unknown option -$OPTARG"
                exit 1
            ;;
        esac
    done
    
    local PS_PATH=`get_pagespeed $PS_VER`
    
    echo $PS_PATH
    # cd `get_nginx $NX_VER`
    # Configure NginX
    # ./configure --add-module=$PS_PATH \
        --with-http_ssl_module \
        --sbin-path=/usr/sbin \
        --conf-path=/etc/nginx/nginx.conf
    
    # Fire it up!
    # make
    # sudo make install
}

# =======================================
get_file() # Get file from web
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
get_pagespeed() # Get pagespeed binaries
# =======================================
# $1  Google Pagespeed version
{
    local PS_GOOG_VER="$1"
    
    local WORKING_FOLDER=$TMPFLDR
    
    local PS_VER=release-${PS_GOOG_VER}-beta
    local PS_SRC=https://github.com/pagespeed/ngx_pagespeed/archive/${PS_VER}.zip
    
    local PS_HOME=ngx_pagespeed-${PS_VER}
    local PS_GOOG_SRC=https://dl.google.com/dl/page-speed/psol/${PS_GOOG_VER}.tar.gz
    
    cd $WORKING_FOLDER
    
    # Download ngx_pagespeed
    unzip -n -qq `get_file $PS_SRC`
    cd $PS_HOME
    
    # Download pagespeed from Google
    tar -xzf `get_file $PS_GOOG_SRC`
    
    echo $WORKING_FOLDER/$PS_HOME
}

# =======================================
get_nginx() # Get nginx binaries
# =======================================
# $1  NginX version
{
    local NX_VER="$1"
    
    local WORKING_FOLDER=$TMPFLDR
    local NX_SRC=http://nginx.org/download/nginx-${NX_VER}.tar.gz
    
    cd $WORKING_FOLDER
    
    # Install NginX and bind pagespeed
    tar -xzf `get_file $NX_SRC`
    
    echo $WORKING_FOLDER/nginx-${NX_VER}
}


# =======================================
# =======================================
# Bootstrap
# =======================================

CURRENT_DIR=$(pwd)
main > ~/nginx-php-centos-out.log 2> ~/nginx-php-centos-errors.log
cd $CURRENT_DIR