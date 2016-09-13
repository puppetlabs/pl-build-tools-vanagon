This README doc is only relevant to employees of Puppet, Inc. who are using our internal build infrastructure.

# Shipping Packages to Our Internal Repositories

## Shipping to production

When your packages have been tested and are ready for use, you can ship them to our internal production pl-build-tools package repositories. Start by pulling in our packaging repo and ensuring it's up to date with:

        bundle exec rake package:implode
        bundle exec rake pacakge:bootstrap

Then you can ship the package with:

        bundle exec ship
        bundle exec rake pl:jenkins:uber_ship

The `ship` command ships packages to pl-build-tools on builds.delivery.puppetlabs.net. The `uber_ship` task then downloads the package(s) from builds.delivery.puppetlabs.net, signs them, and ships them to the appropriate internal repo. This job requires the Release Engineering signing key. It is also assumed that you have ssh access to each of these servers.

Refer to this handy diagram to learn more about what happens during the shipping process:

https://confluence.puppetlabs.com/display/RE/pl-build-tools+shipping+process

## Shipping to pl-build-tools-staging

When building out major new features (e.g, upgrading our GCC toolchain), we use a staging area and repos to avoid breaking the production area while we're working out highly interdependent bugs in our pl-build-tools packages. You can ship to the staging area by setting the `DEV_BUILD` environment variable to true when running the `uber_ship` task:

	rake pl:jenkins:uber_ship DEV_BUILD=true

Note: this currently only works for Deb and RPM based platforms. It has not yet been tested with DMG/SWIX/IPS/MSI platforms.

# Building pl-build-tools With Jenkins

For testing and validation purposes, you can kick off builds from this repository using the [Jenkins Dynamic Vanagon Builder](http://jenkins-release.delivery.puppetlabs.net/job/vanagon_generic_job/).

## Platforms

These are the platforms you'll build your package for. A default list has been provided, but there is no guarantee that it will be up to date, or build all the platforms you care about. Make sure you edit this list to contain the build targets you want. 

## Project

This is the name of the project you're building (e.g, pl-gcc). It corresponds to a project file in the `configs/projects` directory of the repo.

## Repo

This is the repo where your vanagon project lives. Although this jenkins job was created to make building pl-build-tools-vanagon projects simpler, it can technically be used to build any vanagon project. 

## Branch

This is the branch you want to build from. This is especially useful when building a topic branch for testing. If you are building from a custom branch, specify `origin/branch_name` for clarity. If you are building from a tag, use `refs/tags/tag_name`. If you are building from a SHA reference, use `sha`.

# Building for AIX

AIX is a special snowflake.

## Overall

Our AIX boxes also have small filesystems. When buildling larger projects (like gcc), you might need to expand some filesystems.

	chfs -a size=+2G /
	chfs -a size=+1G /tmp
	chfs -a size=+1G /opt

Right now, since AIX isn't a special engine or anything, we're just using an LPAR ssh target to build. This means, you need to clean up your mess when you're done. Normally this means removing quite a few files in /root and wherever your installation path is (/opt/pl-build-tools or /opt/puppetlabs).  You also might need to uninstall some rpms.

Obviously this could (and should) be improved.

## GCC

To build gcc, you have to build an intermediate GCC. There is a boostrapping GCC rpm available at http://pl-build-tools.delivery.puppetlabs.net/aix/6.1/ppc/gcc-aix-boostrap-4.6.4-1.aix6.1.ppc.rpm.
That rpm should be installed to bootstrap any GCC >= 4.8. Beyond that, to build you'll need to export two env variables in the project a few ways.

	export CC=/opt/gcc464/bin/gcc
	export CXX=/opt/gcc464/bin/g++

Once you do that, (you can do this by uncommenting the lines in the aix-61-ppc definition), you *should* be able to build GCC 4.8.2 for AIX 6.1 and 7.1. AIX 5.3 will likely be a more involved and difficult process and we just haven't made it there yet.
