# Overview

This document will help new users of pl-build-tools-vanagon understand how platforms, projects, and components are used to build software packages using this repository. This should be a good introductory tutorial for anyone who has never worked with this repository before, and we'll be glossing over a few details as necessary to ensure you get a good high-level overview of how things work before diving in more deeply.

For our first example, we're going to build one of the simplest projects in this repository, **pl-tar**, for a debian-8-amd64 target platform.

# Initial Setup

Begin by following the instructions in [Setting Up Your Build Environment](https://github.com/puppetlabs/pl-build-tools-vanagon#setting-up-your-build-environment) from the [README.md](https://github.com/puppetlabs/pl-build-tools-vanagon/blob/master/README.md) file for this repository:

```
git clone https://github.com/puppetlabs/pl-build-tools-vanagon.git
cd pl-build-tools-vanagon/
bundle install
```

This tutorial assumes you will be using the vmpooler infrastructure at Puppet, Inc. to obtain a build host. If that's not the case, make sure you've set up an appropriate target build host and specify your builds with the build host's hostname or IP (example below).

# Building A Project

Once you've completed the initial setup, the following command will perform the build:

```
bundle exec build pl-tar debian-8-amd64
```

Again, if you're not running this build with access to our vmpooler system, you'll need to add the IP address of your Debian 8 `target_host` as the final command line argument:

```
bundle exec build pl-tar debian-8-amd64 <debian-8-builder-hostname>
```

So what's happening here? The `build` command comes from [Vanagon](https://github.com/puppetlabs/vanagon), which was added to this project when you ran `bundle install` (note that vanagon is [declared in the Gemfile](https://github.com/puppetlabs/pl-build-tools-vanagon/blob/master/Gemfile)). The `build` command looks for a project definition for `pl-tar`, which it expects to find as `configs/projects/pl-tar.rb`. Then Vanagon looks for a platform definition for debian-8-amd64, which it expects to find as `configs/platforms/debian-8-amd64.rb`. Let's take a closer look at these files, line-by-line. 

# Platform Definitions

Platform definition files (also called platform config files) tell Vanagon certain details about the build target that must be known in order to properly set up the build host with required build dependencies. It also sets a few packaging-specific parameters. The platform definition below is a more heavily-commented version of the one in our repository, describing each variable:

```
config/platforms/debian-8-amd64.rb:
```

```
platform "debian-8-amd64" do |plat|
  # servicedir tells our packaging system where to install service files/init scripts:
  plat.servicedir "/lib/systemd/system"
  # defaultdir tells our packaging system where to install default/sysconfig files:
  plat.defaultdir "/etc/default"
  # servicetype tells our packaging system what init service system is used:
  plat.servicetype "systemd"
  # codename is used for some platforms in packaging metadata:
  plat.codename "jessie"

  # Here we define how the build host is set up for builds. We can add additional
  # build repositories (e.g, to be able to install our own packages), and run
  # arbitrary commands to provision the build system with:
  plat.add_build_repository "http://pl-build-tools.delivery.puppetlabs.net/debian/pl-build-tools-release-#{plat.get_codename}.deb"
  plat.provision_with "export DEBIAN_FRONTEND=noninteractive; apt-get update -qq; apt-get install -qy --no-install-recommends build-essential devscripts make quilt pkg-config debhelper rsync fakeroot"

  # install_build_dependencies_with is used to set the command(s) used to
  # install package requirements. You will always want to use the appropriate
  # flags here to disable interactive confirmation prompts:
  plat.install_build_dependencies_with "DEBIAN_FRONTEND=noninteractive; apt-get install -qy --no-install-recommends "

  # vmpooler_template specifies the vmpooler template used when running builds
  # at Puppet, Inc. If you specify a hostname/IP as the final argument to the
  # Vanagon build command, it will ignore this option and use your hostname for
  # the build instead:
  plat.vmpooler_template "debian-8-x86_64"
  # output_dir can be used to customize where the resulting packages get placed
  # in your output/ directory:
  plat.output_dir File.join("deb", plat.get_codename)
end
```

# Project Definitions

The project definition for `pl-tar` primarily consists of package metadata.

```
config/projects/pl-tar.rb:
```

```
project "pl-tar" do |proj|
  # This is an include mechanism to read in common project settings from
  # pl-build-tools.rb (see below)
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  # Various bits of metadata needed for packaging:
  proj.description "Puppet Labs Gnu Tar"
  proj.version "1.28"
  proj.release "2"
  proj.license "GPLv3"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  # Default settings for :cflags and :ldfags are commonly set in the project file, but
  # can be overidden on a per-platform basis within the component config as needed:
  proj.setting(:cflags, "-I#{proj.includedir}")
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")

  # A project consists of one or more components. In this case, we only have one
  # component we're packaging, tar. The tar component is expected to be found at 
  # configs/components/tar.rb:
  proj.component "tar"
  
  # target_repo is a variable we set when we want to ship a particular project's
  # packages to a public repo, e.g. one of the Puppet Collections repos. We don't
  # make use of it for pl-build-tools packages:
  proj.target_repo ""

  # register_rewrite_rule is used to dynamically re-write urls to point to our
  # internal mirror hosts at Puppet, Inc. and help speed up builds. If you're
  # running builds externally, you'll want to disable this:
  proj.register_rewrite_rule 'http', proj.buildsources_url
end
```

The `pl-build-tools.rb` file that gets included in each of our project configs is listed below. Here we set a lot of variables that you'll recognize if you're familiar with GNU and Autotools-based projects - they are officially defined in [section 7.2.5 of the GNU Coding Standards](https://www.gnu.org/prep/standards/html_node/Directory-Variables.html#Directory-Variables) if you need a refresher.

```
configs/projets/pl-build-tools.rb:
```

```
# Contains all common project settings in one place
platform = proj.get_platform

# platform_triple refers to the triplet used to define a platform for the
# GNU toolchain. Note the use of the is_solaris? method here - we've
# defined a number of these predicate methods in Vanagon's platform.rb:
if platform.is_solaris?
  if platform.architecture == 'i386'
    platform_triple = "#{platform.architecture}-pc-solaris2.#{platform.os_version}"
  else
    platform_triple = "#{platform.architecture}-sun-solaris2.#{platform.os_version}"
  end
elsif platform.architecture == "powerpc" && platform.is_deb?
  platform_triple = "powerpc-linux-gnu"
elsif platform.architecture =~ /arm/
  platform_triple = "arm-linux-gnueabihf"
elsif platform.is_windows?
  if platform.architecture == "x64"
    platform_triple = "x86_64-unknown-mingw32"
  else
    platform_triple = "i686-unknown-mingw32"
  end
  host = "--host #{platform_triple}"
end

proj.setting(:host, host)
proj.setting(:platform_triple, platform_triple)

# Here we're setting various filesystem path variables that
# often get referred to in component configs:
if platform.is_windows?
  proj.setting(:basedir, "C:/tools/pl-build-tools")
  proj.setting(:prefix, "C:/tools/pl-build-tools")
else
  proj.setting(:basedir, "/opt/pl-build-tools")
  if platform_triple.nil?
    proj.setting(:prefix, "/opt/pl-build-tools")
  else
    proj.setting(:prefix, "/opt/pl-build-tools/#{platform_triple}")
  end
end
proj.setting(:sysconfdir, "/etc/pl-build-tools")
proj.setting(:logdir, "/var/log/pl-build-tools")
proj.setting(:piddir, "/var/run/pl-build-tools")
proj.setting(:bindir, File.join(proj.prefix, "bin"))
proj.setting(:libdir, File.join(proj.prefix, "lib"))
proj.setting(:includedir, File.join(proj.prefix, "include"))
proj.setting(:datadir, File.join(proj.prefix, "share"))
proj.setting(:mandir, File.join(proj.datadir, "man"))
proj.setting(:artifactory_url, "https://artifactory.delivery.puppetlabs.net/artifactory")
proj.setting(:buildsources_url, "#{proj.artifactory_url}/generic/buildsources")

# identifier is a bit of metadata used for solaris and osx packages:
if platform.is_solaris?
  proj.identifier "puppetlabs.com"
end

proj.directory proj.basedir

# Here we rewrite public http urls to use our internal source host instead.
# Something like https://www.openssl.org/source/openssl-1.0.0r.tar.gz gets
# rewritten as
# https://artifactory.delivery.puppetlabs.net/artifactory/generic/buildsources/openssl-1.0.0r.tar.gz
proj.register_rewrite_rule 'http', proj.buildsources_url
```

# Component Definitions

A project must consist of one or more components - in the case of `pl-tar`, we just have one component, `tar`:

```
configs/components/tar.rb:
```

```
component "tar" do |pkg, settings, platform|
  # Source-Related Metadata. Keep in mind a project like puppet-agent has
  # metadata totally different from its components, but in the case of a
  # project with a single component, you'll notice some duplication here.
  pkg.version "1.28"
  pkg.url "http://ftp.gnu.org/gnu/tar/tar-1.28.tar.gz"
  pkg.md5sum "6ea3dbea1f2b0409b234048e021a9fd7"

  # Build-time Configuration
  if platform.name =~ /el-4/
    platform.tar = '/bin/tar'
  end

  # You can set arbitrary environment variables during the build by
  # setting the environment variable, which is a hash. In this case,
  # tar needs an env var set to run configure as root:
  pkg.environment "FORCE_UNSAFE_CONFIGURE" => "1"

  # Build Commands
  # You can define arbitrary build commands in each of these three
  # sections: pkg.configure, pkg.build, and pkg.install.
  # settings[:basedir] was defined in pl-build-tools.rb:
  pkg.configure do
    "./configure --prefix=#{settings[:basedir]}"
  end

  pkg.build do
    # platform[:make] is defined in vanagon:
    "#{platform[:make]}"
  end

  # When you need to run multiple commands, define the section as an array:
  pkg.install do
    [
      "#{platform[:make]} install",
      "rm -rf #{settings[:basedir]}/share/info"
    ]
  end
end
```

# Further Reading and Resources

The variables used in these config files are defined either within the [pl-build-tools-vanagon repository](https://github.com/puppetlabs/pl-build-tools-vanagon), or in [Vanagon](https://github.com/puppetlabs/vanagon) itself. A simple recursive `grep` invocation is generally all it takes to focus your exploration to relevant files.

Further questions about this code base should be discussed on the [puppet-dev mailing list](https://groups.google.com/forum/#!forum/puppet-dev).
