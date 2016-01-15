component "pdcurses" do |pkg, settings, platform|

  pkg.version "3.4"
  pkg.md5sum "4e04e4412d1b1392a7f9a489b95b331a"
  pkg.url "http://buildsources.delivery.puppetlabs.net/PDCurses-#{pkg.get_version}.tar.gz"

  makefile = "Makefile"
  if platform.is_windows?
    arch = platform.architecture == "x64" ? "64" : "32"

    mingw_root = "C:/tools/mingw#{arch}"
    pkg.environment "PATH" => "$$PATH:#{mingw_root}/bin"
    pkg.environment "CYGWIN" => "nodosfilewarning winsymlinks:native"
    pkg.environment "LIB" => "#{mingw_root}/lib"
    pkg.environment "INCLUDE" => "#{mingw_root}/include"
    pkg.environment "CC" => "#{mingw_root}/bin/gcc"
    pkg.environment "CXX" => "#{mingw_root}/bin/g++"

    pkg.apply_patch "resources/patches/pdcurses/0001-Fix-dllexport-dllimport-for-mingw.patch"
    pkg.apply_patch "resources/patches/pdcurses/0002-gccwin32-pdcurses-3.4-build.diff"

    makefile = "gccwin32.mak"
    make_options = "-C win32"
  end

  if platform.is_windows?
    pkg.build do
      [
        # Build static libraries first to avoid declspec(__dllexport) symbols
        "#{platform[:make]} #{make_options} -f #{makefile} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) all",

        # These compiled files are removed to correct link issues
        "rm win32/*.o",
        "rm win32/*.exe",

        # Now build the dlls using the existing compiled files
        "#{platform[:make]} #{make_options} -f #{makefile} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) DLL=Y all"
      ]
    end
  end

  # The windows makefile doesn't seem to have an effective install task, so
  # we get to install the necessary files by hand, yay!
  if platform.is_windows?
    pkg.install_file "win32/pdcurses.dll", "#{settings[:bindir]}/pdcurses.dll"
    pkg.install_file "win32/libpdcurses.dll.a", "#{settings[:libdir]}/libpdcurses.dll.a"
    pkg.install_file "win32/libpdcurses.a", "#{settings[:libdir]}/libpdcurses.a"
    pkg.install_file "curses.h", "#{settings[:includedir]}/curses.h"
    pkg.install_file "panel.h", "#{settings[:includedir]}/panel.h"
    pkg.install_file "term.h", "#{settings[:includedir]}/term.h"
  end
end
