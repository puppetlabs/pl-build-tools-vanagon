# Overview

The pl-build-tools-vanagon repo uses [vanagon](https://github.com/puppetlabs/vanagon) to build packages that satisfy build-time dependencies for puppet software: artifacts built using this repo are _not_ included in final builds of puppet software. For runtime dependency packages, see the [puppet-runtime project](https://github.com/puppetlabs/puppet-runtime) instead.

This project exists to create a consistent build process for use in our continuous integration systems, and to provide versions of build tools that may not be available as system tools on all of the target platforms that Puppet Enterprise supports.

At Puppet Inc, we ship these packages to repositories on our internal network only, but you may build them locally: see the general [vanagon instructions](https://github.com/puppetlabs/vanagon#configuration-and-usage) and the examples below to get started.

# Available projects

The tools and libraries you can build using this repository can be found in the [`configs/projects`](configs/projects) directory. For example:

* pl-gcc
* pl-boost (build requires pl-gcc)
* pl-cmake (build requires pl-gcc)
* pl-yaml-cpp (build requires pl-gcc, pl-boost, and pl-cmake)

...and others.

These projects all generate packages with a "pl-" prefix (for Puppet Labs) and are installed under `/opt/pl-build-tools` so that they do not conflict with equivalent system packages. Note that not all projects are guaranteed to successfully build on every platform listed in [`configs/platforms`](configs/platforms).

# Setting Up Your Build Environment

A modern Linux or Mac OS X operating system with a recent version of Ruby (1.9 or later) with the bundler gem is required to run these builds.

This repository makes use of the [Vanagon](https://github.com/puppetlabs/vanagon) build system, which is written in Ruby. The [Gemfile](https://github.com/puppetlabs/pl-build-tools-vanagon/blob/master/Gemfile) included in this repo specifies all of the needed ruby libraries to build a target project. Additionally, vanagon requires a virtualization engine to build target packages in. More information on the different virtualization engine options is available in the vanagon repo.

Begin by cloning this repository:

	git clone https://github.com/puppetlabs/pl-build-tools-vanagon.git

and install the required Ruby gems with the `bundle install` command:

	cd pl-build-tools-vanagon
	bundle install

## Using `VANAGON_LOCATION` to specify a custom Vanagon source

By default, our [Gemfile](https://github.com/puppetlabs/pl-build-tools-vanagon/blob/master/Gemfile) specifies a particular version of Vanagon (typically, the latest master branch checked out from the vanagon GitHub repo). There are times where you may wish to use a customized version of vanagon from a git repository branch, or a copy of Vanagon stored locally on your filesystem. You can do this by setting the environment variable `VANAGON_LOCATION` when running bundle install:

* `0.3.14` - Use a specific git tag from the Vanagon git repo
* `git@github.com:puppetlabs/vanagon#main` - Customize the remote git location and/or branch
* `file:///workspace/vanagon` - Absolute file path
* `file://../vanagon` - File path relative to the project directory

# Examples

Let's say you want to build pl-gcc for Debian 8 (Jessie) 64-bit. First verify that you have a project pl-gcc (`configs/projects/pl-gcc.rb`) and a platform file for Debian 8 (`configs/platforms/debian-8-amd64.rb`). Ensure you are current in the root directory of the repo, and run:

	bundle exec build pl-gcc debian-8-amd64 <target host>

where `target host` is the hostname or IP address of a 64-bit Debian 8 server or VM that the build will be run on. Internally at Puppet we have a dynamic vmpooler infrastructure that provides VMs for all of our target platforms, so `target host` is not necessary in that case.

The build process will take the configuration defined in `configs/projects/pl-gcc.rb` and build any component dependencies required from `configs/components`. The final project will then be packaged and made available under the output/ directory.

## Build Arguments

The `build` command above comes from the vanagon gem, and it has a number of position-dependent arguments:

### project name

The name of the project to build. A file named `project_name.rb` must be present in the configs/projects directory.

### platform name

The name of the platform to build for. A file named `platform_name.rb` must be present in the configs/platforms directory.

You can specify multiple platforms to build for at once by using a comma-separated list (`platform1,platform2` for example).

### target host [optional]

Target host is an optional argument which overrides the host selection. Instead of using a vm collected from the pooler, the build will attempt to ssh to the target host as root.

If you're building multiple platforms at once, multiple target hosts can also be specified using a comma-separated list (example: `host1,host2`). If fewer targets are specified than platforms, the default build engine (the pooler) will be used for platforms without a target host. If more target hosts are specified than platforms, the extra target hosts will be ignored.

# How To Add a New Platform

To add a new platform, begin by adding the platform definition file in configs/platforms. Then additional customizations when building components for that platform can be added to the component definitions in configs/components. If this is an entirely new platform (and not just a new version of a platform already supported), you may need to make changes in vanagon as well. Using the build dependency graph above, start with pl-gcc and work your way through the dependency chain. Once packages for all of the relevant pl-build-tools have been generated, you can then move on to building a puppet-agent package using the [puppet-agent](https://github.com/puppetlabs/puppet-agent) repository.

# How To Add a New Project

New projects require an entry in `configs/projects`. A file for anything this project includes, with instructions on how to configure and build it, should also be added under `configs/components` if it does not already exists. Refer to existing projects in this repo or to [the example in vanagon](https://github.com/puppetlabs/vanagon/tree/master/examples) for more details.

# Support

Puppet, Inc. offers community-based support for this repository. Questions should be directed to the [Puppet Developers mailing list](https://groups.google.com/forum/#!forum/puppet-dev). Some code in this repository is related to platforms available only to Puppet Enterprise users like Solaris and AIX; we only offer support for those platforms to official partners of Puppet, Inc.
