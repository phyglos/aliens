#!/bin/bash

build_pack()
{
    # Copy binaries
    bandit_mkdir $BUILD_PACK/$PHY_ECLIPSE_ROOT/$PHY_ECLIPSE_APP
    cp -vR eclipse/* $BUILD_PACK/$PHY_ECLIPSE_ROOT/$PHY_ECLIPSE_APP

    # Install desktop 
    bandit_mkdir $BUILD_PACK/usr/share/applications
    cat > $BUILD_PACK/usr/share/applications/${PHY_ECLIPSE_APP}.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Name=Eclipse CPP (${PHY_ECLIPSE_APP})
GenericName=Eclipse CPP
Comment="Eclipse IDE for C/C++ Developers"
Type=Application
Icon=$PHY_ECLIPSE_ROOT/$PHY_ECLIPSE_APP/icon.xpm
Categories=Development
Exec=$PHY_ECLIPSE_ROOT/$PHY_ECLIPSE_APP/eclipse
Terminal=false
StartupNotify=false
EOF
}
