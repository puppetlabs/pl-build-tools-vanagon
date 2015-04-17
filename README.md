This is the project that houses building out the C++ toolchain for our projects.



# Building for AIX

AIX is a special snowflake.

## Overall

Our AIX boxes also have small filesystems. When buildling larger projects (like
gcc), you might need to expand some filesystems.


    chfs -a size=+2G /
    chfs -a size=+1G /tmp
    chfs -a size=+1G /opt

Right now, since AIX isn't a special engine or anything, we're just using an
LPAR ssh target to build. This means, you need to clean up your mess when
you're done. Normally this means removing quite a few files in /root and
wherever your installation path is (/opt/pl-build-tools or /opt/puppetlabs).
You also might need to uninstall some rpms.

Obviously this could (and should) be improved.

## GCC

To build gcc, you have to build an intermediate GCC.
There is a boostrapping GCC rpm available at
http://pl-build-tools.delivery.puppetlabs.net/aix/6.1/ppc/gcc-aix-boostrap-4.6.4-1.aix6.1.ppc.rpm.
That rpm should be installed to bootstrap any GCC >= 4.8. Beyond that, to build
you'll need to export two env variables in the project a few ways.

    export CC=/opt/gcc464/bin/gcc
    export CXX=/opt/gcc464/bin/g++

Once you do that, (you can do this by uncommenting the lines in the aix-61-ppc
definition), you *should* be able to build GCC 4.8.2 for AIX 6.1 and 7.1. AIX
5.3 will likely be a more involved and difficult process and we just haven't
made it there yet.
