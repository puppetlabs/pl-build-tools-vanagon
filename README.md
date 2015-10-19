# Overview

The pl-build-tools-vanagon repo is where all the automation lives to build packages to satisfy buildtime dependenices that we do not want to make publically available at this time. All packages built with this automation should be shipped to [the pl-build-tools repo](http://pl-build-tools.delivery.puppetlabs.net/). The release packages available in that repo are created with [the puppetlabs release repository] (https://github.com/puppetlabs/puppetlabs-release/tree/pl-build-tools).

# Runtime Requirements

The [Gemfile](https://github.com/puppetlabs/pl-build-tools-vanagon/blob/master/Gemfile) specifies all of the needed ruby libraries to build a given project in this repo. Additionally, the automation requires a virtualization engine to build within for each desired package. More information on the different virtualization engine options is available in [the vanagon repo](https://github.com/puppetlabs/vanagon#-e-engine---engine-engine).

## Environment variables
#### VANAGON\_LOCATION
The location of Vanagon in the Gemfile can be overridden with the environment variable `VANAGON_LOCATION`. Can be set prior to `bundle install` or updated with `bundle update`.

* `0.3.14` - Specific tag from the Vanagon git repo
* `git@github.com:puppetlabs/vanagon#master` - Remote git location and tag
* `file:///workspace/vanagon` - Absolute file path
* `file://../vanagon` - File path relative to the project directory

# Building packages
This repo uses automation in [vanagon](https://github.com/puppetlabs/vanagon) to build packages.

## Arguments (position dependet)
More detailed and up to date information can be found in [the vanagon repo](https://github.com/puppetlabs/vanagon#configuration-and-usage)

### project name
The name of the project to build, and a file named <project_name>.rb must be present in configs/projects in the working directory.

### platform name
The name of the platform to build against, and a file named <platform_name>.rb must be present in configs/platforms in the working directory.

Platform can also be a comma separated list of platforms such as platform1,platform2.

### target host [optional]
Target host is an optional argument to override the host selection. Instead of using a vm collected from the pooler, the build will attempt to ssh to target as the root user.

If building on multiple platforms, multiple targets can also be specified using a comma separated list such as host1,host2. If less targets are specified than platforms, the default engine (the pooler) will be used for platforms without a target. If more targets are specified than platforms, the extra will be ignored.

## Example

To build a pl-gcc package for Debian 8, Jessie 64bit, first verify the existence and contents of both `configs/projects/pl-gcc.rb` and `configs/platforms/debian-8-amd64.rb`.

    bundle install
    bundle exec build pl-gcc debian-8-amd64

This will access and configure the virtualization engine defined in `configs/platforms/debian-8-amd64.rb`. It will then take the build instructions defined in `configs/projects/pl-gcc.rb`, as well as any dependencies that are defined in `configs/components` that are pulled in for the pl-gcc project. It will then follow the instructions, building out first any needed dependencies, then the final project. The needed files will then be packaged up in a package compatable with dpkg standards, and make it available locally.

## Building with jenkins
To save time, you can also kick off a build using [Jenkins](http://jenkins-staging.delivery.puppetlabs.net/view/Build%20Toolchain/job/pl-build-tools_dynamic/). The job you want is hosted on jenkins-staging, so it's really slow (as of 2015-07-10). Be patient. This job will build your packages, ship them to builds.delivery.puppetlabs.net, and create repos and repo configs for you.

#### PLATFORMS
These are the platforms you'll build your package for. A default list has been provided for you, but there is no guarantee that it will be up to date, or will build all that platforms you care about. Make sure you edit this list to contain the build targets you want.

#### PROJECT
This is the project you want to build. It corresponds to the project file in `configs/projects` in your repo.

#### REPO
The repo where your vanagon project lives. Although this job was created to make building pl-build-tools-vanagon projects simpler, it can be used to build any vanagon project.

#### BRANCH
This is the branch you want to build from. This is especially useful when building a topic branch for testing. If you are building from a branch, specify `origin/branch_name` for clarity. If you are building from a tag, use `refs/tags/tag_name`. If you are building from a sha reference, use `sha`.


## Building for AIX
AIX is a special snowflake.

#### Overall
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

#### GCC
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

# Shipping packages to builds.delivery.puppetlabs.net/pl-build-tools
This is meant for packages in active development that require testing.


To ship a built archive, run

    bundle exec ship

This will ship packages to builds.delivery.puppetlabs.net/pl-build-tools, and can be found under the sha associated with the state of the repo when the build was kicked off.

To make repos available on builds.delivery.puppetlabs.net/pl-build-tools in order to help make testing easier, run

    bundle exec repo

If you are only shipping debian packages, run

    bundle exec repo deb

If you are only shipping rpm packages, run

    bundle exec repo rpm

This will create repos and repo_configs to allow you to more easily install and test packages you have made available on builds.delivery.puppetlabs.net.

# Shipping packages to pl-build-tools.delivery.puppetlabs.net
This is meant for packages that have been tested, and are ready for a final ship. The packages to be shipped must already be available on builds.delivery.puppetlabs.net.

    rake package:implode package:bootstrap
    rake pl:jenkins:uber_ship

This will download packages from builds.delivery.puppetlabs.net, sign them, and ship them to the appropriate repo on pl-build-tools.delivery.puppetlabs.net. This job requires the RE signing key.

# Adding new platforms
New platforms require a new platform entry in configs/platforms. Generally, this is all that needs to happen for a new platform, especially if it's a new version of a platform that already exists. However, if it's a new platform entirely, not just a new version, ther will likely be automation changes that are required. Make sure you know how the package management system on the new platform works, and check the vanagon repo to see if there are any vanagon changes required for this new plaform. If we've done things well, you should receive fairly explicit error messages about where the vanagon automation needs to be updated

# Adding new projects
New projects require an entry in `configs/projects`. A file for anything this project includes, with instructions on how to configure and build it, should also be added to `condigs/components` if it does not already exist. Refer to existing projects in this repo or to [the example in vanagon](https://github.com/puppetlabs/vanagon/tree/master/examples) for more details.
