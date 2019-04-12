#!/bin/bash

case ${BANDIT_TARGET_ARCH} in
    i?86)
        ARCH=i386-linux
        ;;
    x86_64)
        ARCH=x86_64-linux
        ;;
esac

script_run()
{
    cat > /etc/profile.d/texlive.sh << EOF
export PATH=\$PATH:${PHY_TEXLIVE_HOME}/2018/bin/$ARCH

export MANPATH=\$MANPATH:${PHY_TEXLIVE_HOME}/texmf-local/doc/man
export INFOPATH=\$INFOPATH:${PHY_TEXLIVE_HOME}/texmf-local/doc/info
EOF
}

script_reverse()
{
    rm -f /etc/profile.d/texlive.sh
}
