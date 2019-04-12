#!/bin/bash

build_pack()
{
    cat > ./texlive.profile <<EOF
selected_scheme scheme-basic

TEXDIR         $BUILD_PACK/$PHY_TEXLIVE_HOME/2018
TEXMFLOCAL     $BUILD_PACK/$PHY_TEXLIVE_HOME/texmf-local
TEXMFSYSCONFIG $BUILD_PACK/$PHY_TEXLIVE_HOME/2018/texmf-config
TEXMFSYSVAR    $BUILD_PACK/$PHY_TEXLIVE_HOME/2018/texmf-var

TEXMFHOME   $BUILD_PACK/~/texmf
TEXMFCONFIG $BUILD_PACK/~/.texlive2018/texmf-config
TEXMFVAR    $BUILD_PACK/~/.texlive2018/texmf-var

instopt_adjustpath 1
instopt_adjustrepo 1
instopt_letter 0
instopt_portable 1
instopt_write18_restricted 1
tlpdbopt_autobackup 1
tlpdbopt_backupdir tlpkg/backups
tlpdbopt_create_formats 1
tlpdbopt_desktop_integration 0
tlpdbopt_file_assocs 1
tlpdbopt_generate_updmap 0
tlpdbopt_install_docfiles 0
tlpdbopt_install_srcfiles 0
tlpdbopt_post_code 1
tlpdbopt_sys_bin  $BUILD_PACK/$PHY_TEXLIVE_HOME/2018/bin
tlpdbopt_sys_info $BUILD_PACK/$PHY_TEXLIVE_HOME/2018/info
tlpdbopt_sys_man  $BUILD_PACK/$PHY_TEXLIVE_HOME/2018/man
tlpdbopt_w32_multi_user 1
EOF
    
    TEXLIVE_INSTALL_ENV_NOCHECK=yes      \
    TEXLIVE_INSTALL_NO_WELCOME=yes       \
    TEXLIVE_INSTALL_NO_CONTEXT_CACHE=yes \
    ./install-tl -persistent-downloads   \
                 -profile texlive.profile
}
