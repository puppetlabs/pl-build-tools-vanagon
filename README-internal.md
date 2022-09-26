This README doc is only relevant to employees of Puppet, Inc. who are using our internal build infrastructure.

# Shipping Packages to Our Internal Repositories

## Shipping to production

When packages have been tested and are ready for use, ship them to the internal production pl-build-tools package repositories.

Ship the package with:

        bundle exec ship
        bundle exec rake pl:jenkins:uber_ship

The `ship` command ships packages to pl-build-tools on builds.delivery.puppetlabs.net. The `uber_ship` task then downloads the package(s) from builds.delivery.puppetlabs.net, signs them, and ships them to the appropriate internal repo. This job requires the Release Engineering signing key. It is also assumed that you have ssh access to each of these servers.

Refer to this handy diagram to learn more about what happens during the shipping process:

https://confluence.puppetlabs.com/display/RE/pl-build-tools+shipping+process

## Shipping to pl-build-tools-staging

When building new features (like upgrading the GCC toolchain), we use a staging area and repos to avoid breaking the production area while we're working out bugs in the pl-build-tools packages.

Ship to the staging area by setting the `DEV_BUILD` environment variable to true when running the `uber_ship` task:

	rake pl:jenkins:uber_ship DEV_BUILD=true

Note that this currently only works for Deb and RPM based platforms.

# Building pl-build-tools With Jenkins

For testing and validation purposes, trigger builds from this repository using the [Jenkins Dynamic Vanagon Builder](https://jenkins-platform.delivery.puppetlabs.net/view/vanagon-generic-builder).

## Platforms

This is a list of target platforms for the package. A default list has been provided, but there is no guarantee that it will be correct. Edit this list to contain the build targets you want.

## Project

This is the name of the project to be built (`pl-gcc`, for example). It corresponds to a project file in the `configs/projects` directory in this source repository.

## Repo

This is the repo where your vanagon project lives. In this case `pl-build-tools-vanagon`.

## Branch

This is the branch in the Repo to build. To build from a custom branch, specify `origin/branch_name` for clarity. To build from a tag, use `refs/tags/tag_name`. To build from an arbitrary sha, just list the sha alone.

# Building for AIX

AIX is a special snowflake.

## Overall

The AIX boxes also have small filesystems. When buildling larger projects (like gcc), some filesystems likely will need to be expanded:

	chfs -a size=+2G /
	chfs -a size=+1G /tmp
	chfs -a size=+1G /opt

Right now, since AIX isn't a special engine or anything, we're just using an LPAR ssh target to build. This means, you need to clean up your mess when you're done. Normally this means removing quite a few files in /root and wherever your installation path is (/opt/pl-build-tools or /opt/puppetlabs).  You also might need to uninstall some rpms.

Obviously this could (and should) be improved.

## GCC

To build gcc, you must build an intermediate GCC. There is a boostrapping GCC rpm available at http://pl-build-tools.delivery.puppetlabs.net/aix/6.1/ppc/gcc-aix-boostrap-4.6.4-1.aix6.1.ppc.rpm.
That rpm should be installed to bootstrap any GCC >= 4.8.

Then, two environment variables are required to use the intermedidate:

	export CC=/opt/gcc464/bin/gcc
	export CXX=/opt/gcc464/bin/g++

With that, building GCC *should* work for for AIX 6.1 and 7.1. AIX 5.3 will likely be a more involved and difficult process and we just haven't made it there yet.
