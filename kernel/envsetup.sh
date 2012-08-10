function help() {
cat <<EOF

tkboy adds the following functions to your environment:
All command start with "tkboy_":
- make:       Make kernel for pandaboard.
- cd:         Go to the kernel's root dir.
- find:       Find on all local files related to pandaboard.
- grep:       Greps on local source files.

Beside, use tkboy_find_all search all files.

EOF
    T=/home/tkboy/tkboy/panda/omap/
    XXP="-path ./arch/powerpc -prune -o \
       -path ./arch/mips -prune -o \
       -path ./arch/m68k -prune -o \
       -path ./arch/xtensa -prune -o \
       -path ./arch/alpha -prune -o \
       -path ./arch/blackfin -prune -o \
       -path ./arch/sparc -prune -o \
       -path ./arch/x86 -prune -o \
       -path ./arch/avr32 -prune -o \
       -path ./arch/microblaze -prune -o \
       -path ./arch/h8300 -prune -o \
       -path ./arch/cris -prune -o \
       -path ./arch/unicore32 -prune -o \
       -path ./arch/sh -prune -o \
       -path ./arch/frv -prune -o \
       -path ./arch/arm/mach-s3c2410 -prune -o \
       -path ./arch/arm/mach-s3c2400 -prune -o \
       -path ./arch/arm/mach-s3c2412 -prune -o \
       -path ./arch/arm/mach-s3c64xx -prune -o \
       -path ./arch/arm/plat-s3c24xx -prune -o \
       -path ./arch/arm/mach-ixp4xx -prune -o \
       -path ./arch/arm/mach-pnx4008 -prune -o \
       -path ./arch/arm/mach-mv78xx0 -prune -o \
       -path ./arch/arm/mach-davinci -prune -o \
       -path ./arch/arm/mach-s5p64x0 -prune -o \
       -path ./arch/arm/mach-s5pc100 -prune -o \
       -path ./arch/arm/mach-s5pv210 -prune -o \
       -path ./arch/arm/mach-realview -prune -o \
       -path ./arch/arm/mach-exynos4 -prune -o \
       -path ./arch/arm/plat-iop -prune -o \
       -path ./arch/arm/mach-iop32x -prune -o \
       -path ./arch/arm/mach-iop33x -prune -o \
       -path ./arch/arm/mach-nomadik -prune -o \
       -path ./arch/arm/plat-nomadik -prune -o \
       -path ./arch/arm/mach-msm -prune -o \
       -path ./arch/arm/mach-at91 -prune -o \
       -path ./arch/arm/plat-samsung -prune -o \
       -path ./arch/arm/mach-spear3xx -prune -o \
       -path ./arch/arm/mach-spear6xx -prune -o \
       -path ./arch/arm/plat-spear -prune -o \
       -path ./arch/arm/plat-pxa -prune -o \
       -path ./arch/arm/mach-pxa -prune -o \
       -path ./arch/arm/mach-versatile -prune -o \
       -path ./arch/arm/mach-lpc32xx -prune -o \
       -path ./arch/arm/mach-sa1100 -prune -o \
       -path ./arch/arm/mach-mxs -prune -o \
       -path ./arch/arm/plat-orion -prune -o \
       -path ./arch/arm/mach-orion5x -prune -o \
       -path ./arch/arm/mach-dove -prune -o \
       -path ./arch/arm/mach-vt8500 -prune -o \
       -path ./arch/arm/mach-ixp2000 -prune -o \
       -path ./arch/arm/mach-ks8695 -prune -o \
       -path ./arch/arm/mach-mmp -prune -o \
       -path ./arch/arm/mach-shmobile -prune -o \
       -path ./arch/arm/mach-w90x900 -prune -o \
       -path ./arch/arm/mach-ep93xx -prune -o \
       -path ./arch/arm/mach-gemini -prune -o \
       -path ./arch/arm/mach-kirkwood -prune -o \
       -path ./arch/arm/mach-tegra -prune -o \
       -path ./arch/arm/plat-mxc -prune -o \
       -path ./arch/arm/mach-u300 -prune -o \
       -path ./arch/arm/mach-ux500 -prune -o"

    XXN="-name .repo -prune -o \
       -name .git -prune -o"

    SAC="-name *.c -o -name *.cc"
    SAH="-name *.h"
    SAA="-name *.s -o -name *.S"
    SAM="-name Makefile"
    SAK="-name Kconfig"

    GGG=" xargs -0 grep --color -n "

    #local A
    #A=""
    #for i in `cat $T/envsetup.sh | sed -n "/^function /s/function \([a-z_]*\).*/\1/p" | sort`; do
    #  A="$A $i"
    #done
    #echo $A
}


function tkboy_make()
{
    make ARCH=arm SUBARCH=arm CROSS_COMPILE=/home/tkboy/tkboy/panda/android/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi- "$@"
}

function tkboy_cd()
{
    cd $T
}

function tkboy_find()
{
    if [ "$#" = 1 ] ; then
        find . $XXP $XXN -type f -name "*$@*" -print
    elif [ "$#" = 2 ] ; then
        if [ "$1" = "all" ] ; then
            find . $XXN -type f -name "*$2*" -print
        elif [ "$1" = "end" ] ; then
            find . $XXP $XXN -type f -name "$2" -print
        elif [ "$1" = "allend" ] ; then
            find . $XXN -type f -name "$2" -print
        else
            echo "Usage: "
            echo "    tkboy_find [all|end|allend] text"
            echo ""
        fi
    else
        echo "Usage: "
        echo "    tkboy_find [all|end|allend] text"
        echo ""
    fi
}

function tkboy_grep()
{
    if [ "$#" = 1 ] ; then
        find . $XXP $XXN -type f \( $SAC -o $SAA -o $SAH \) -print0 | $GGG "$@"
    elif [ "$#" = 2 ] ; then
	if [ "$1" = "cs" ] ; then
            find . $XXP $XXN -type f \( $SAC -o $SAA \) -print0 | $GGG "$2"
        elif [ "$1" = "hcs" ] ; then
            find . $XXP $XXN -type f \( $SAC -o $SAA -o $SAH \) -print0 | $GGG "$2"
        elif [ "$1" = "h" ] ; then
            find . $XXP $XXN -type f $SAH -print0 | $GGG "$2"
        elif [ "$1" = "c" ] ; then
            find . $XXP $XXN -type f \( $SAC \) -print0 | $GGG "$2"
        elif [ "$1" = "s" ] ; then
            find . $XXP $XXN -type f \( $SAA \) -print0 | $GGG "$2"
        elif [ "$1" = "m" ] ; then
            find . $XXN -type f $SAM -print0 | $GGG "$2"
        elif [ "$1" = "k" ] ; then
            find . $XXN -type f $SAK -print0 | $GGG "$2"
        elif [ "$1" = "help" ] ; then
            find Documentation/ -print0 | $GGG "$2"
        else
            echo "Usage: tkboy_grep [h|c|s|cs|hcs|m|k|help] text"
            echo " - h:     *.h"
            echo " - c:     *.c *.cc"
            echo " - s:     *.s *.S"
            echo " - cs:    c and s"
            echo " - hcs:   h, c and s"
            echo " - m:     Makefiles"
            echo " - k:     Kconfigs"
            echo " - help:  Documentations"
            echo "Defaut: hcs"
            echo ""
        fi
    else
        echo "Usage: tkboy_grep [h|c|s|cs|hcs|m|k|help] text"
        echo " - h:     *.h"
        echo " - c:     *.c *.cc"
        echo " - s:     *.s *.S"
        echo " - cs:    c and s"
        echo " - hcs:   h, c and s"
        echo " - m:     Makefiles"
        echo " - k:     Kconfigs"
        echo " - help:  Documentations"
        echo "Defaut: hcs"
        echo ""
    fi
}


if [ "x$SHELL" != "x/bin/bash" ]; then
    case `ps -o command -p $$` in
        *bash*)
            ;;
        *)
            echo "WARNING: Only bash is supported, use of other shell would lead to erroneous results"
            ;;
    esac
fi

help
