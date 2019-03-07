#!/bin/bash

alien_install()
{
    case $BANDIT_TARGET_ARCH in
    i?86)
        sh ./VirtualBox-5.2.22-126460-Linux_x86.run
        ;;
    x86_64)
        sh ./VirtualBox-5.2.22-126460-Linux_amd64.run
        ;;
    esac
}

