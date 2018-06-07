#!/bin/bash
#
# This is a script for build avalon851 controller image
#
#  Copyright June 2018 Zhenxing Xu <xuzhenxing@canaan-creative.com>
#
# OPENWRT_DIR is ${ROOT_DIR}/openwrt, build the image in it
#
# Learn bash: http://explainshell.com/

set -e

SCRIPT_VERSION=20180606

# OpenWrt repo
openwrt_repo="git://github.com/Canaan-Creative/openwrt-archive.git"

# OpenWrt feeds
FEEDS_CONF_URL=https://raw.github.com/XzxEmbedded/Image-Config-Tool/master/openwrt/feeds.conf
DEV_CONF_URL=https://raw.github.com/XzxEmbedded/Image-Config-Tool/master/openwrt/rpi3.conf

which wget > /dev/null && DL_PROG=wget
which curl > /dev/null && DL_PROG=curl

# According to http://wiki.openwrt.org/doc/howto/build
unset SED
unset GREP_OPTIONS
[ "`id -u`" == "0" ] && echo "[ERROR]: Please use non-root user" && exit 1

# Adjust CORE_NUM by yourself
[ -z "${CORE_NUM}" ] && CORE_NUM="$(expr $(nproc) + 1)"
DATE=`date +%Y%m%d`
SCRIPT_FILE="$(readlink -f $0)"
SCRIPT_DIR=`dirname ${SCRIPT_FILE}`
OPENWRT_DIR=${SCRIPT_DIR}/openwrt
echo $OPENWRT_DIR

# Get OpenWrt source codes
prepare_source() {
    cd ${SCRIPT_DIR}
    if [ ! -d openwrt ]; then
        eval OPENWRT_URL=\${owrepo}
        PROTOCOL="`echo ${OPENWRT_URL} | cut -d : -f 1`"

        case "${PROTOCOL}" in
            git)
                GITBRANCH="`echo ${OPENWRT_URL} | cut -s -d @ -f 2`"
                GITREPO="`echo ${OPENWRT_URL} | cut -d @ -f 1`"
                [ -z ${GITBRANCH} ] && GITBRANCH=master
                git clone ${GITREPO} openwrt
                cd openwrt && git checkout ${GITBRANCH}
                cd ..
                ;;
            svn)
                SVNVER="`echo ${OPENWRT_URL} | cut -s -d @ -f 2`"
                SVNREPO="`echo ${OPENWRT_URL} | cut -d @ -f 1`"
                if [ -z ${SVNVER} ]; then
                    svn co ${SVNREPO}@${SVNVER} openwrt
                else
                    svn co ${SVNREPO} openwrt
                fi
                ;;
            *)
                echo "Protocol not supported"; exit 1;
                ;;
        esac
    fi
}

prepare_feeds() {
    cd ${OPENWRT_DIR}
    $DL_PROG ${FEEDS_CONF_URL} && \
    ./scripts/feeds update -a && \
    ./scripts/feeds install -a
}

prepare_config() {
    cd ${OPENWRT_DIR}
    $DL_PROG ${DEV_CONF_URL}
}

build_image() {
    cd ${OPENWRT_DIR}
    yes "" | make oldconfig > /dev/null
    # clean before build
    make -j${CORE_NUM} clean world
}

cleanup() {
    cd ${ROOT_DIR}
    rm -rf openwrt/ > /dev/null
}

show_help() {
    echo "help messages"
}

# Paramter is null, display help messages
if [ "$#" == "0" ]; then
    $0 --help
    exit 0
fi

for i in "$@"
do
    case $i in
        --help)
            show_help
            exit
            ;;
        --build)
            prepare_source && prepare_feeds && prepare_config && build_image
            ;;
        --cleanup)
            cleanup
            ;;
        *)
            show_help
            exit
            ;;
    esac
done