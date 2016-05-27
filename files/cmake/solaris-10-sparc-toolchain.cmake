# this one is important
SET(CMAKE_SYSTEM_NAME SunOS)
#this one not so much
SET(CMAKE_SYSTEM_VERSION 5.10)
SET(CMAKE_SYSTEM_PROCESSOR sparc)

# specify the cross compiler
SET(PL_TOOLS_ROOT        /opt/pl-build-tools)
SET(PL_TOOLS_PREFIX      ${PL_TOOLS_ROOT}/sparc-sun-solaris2.10)
SET(CMAKE_C_COMPILER     ${PL_TOOLS_ROOT}/bin/sparc-sun-solaris2.10-gcc)
SET(CMAKE_CXX_COMPILER   ${PL_TOOLS_ROOT}/bin/sparc-sun-solaris2.10-g++)
SET(CMAKE_AR             ${PL_TOOLS_PREFIX}/bin/ar CACHE FILEPATH "Archiver")
SET(CMAKE_LINKER         ${PL_TOOLS_ROOT}/bin/sparc-sun-solaris2.10-gcc CACHE PATH "Linker Program")
SET(CMAKE_NM             ${PL_TOOLS_PREFIX}/bin/nm )

# where is the target environment
SET(CMAKE_FIND_ROOT_PATH ${PL_TOOLS_PREFIX})

# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ALWAYS)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ALWAYS)

SET(CMAKE_C_FLAGS "-pthread -fPIC ${CMAKE_C_FLAGS}" CACHE STRING "" FORCE)
SET(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS}" CACHE STRING "" FORCE)
SET(CMAKE_CXX_FLAGS_RELEASE "-O2 -DNDEBUG" CACHE STRING "" FORCE)

# update RPATH so our custom libraries can be found
# use, i.e. don't skip the full RPATH for the build tree
SET(CMAKE_SKIP_BUILD_RPATH  FALSE)

# when building, don't use the install RPATH already
# (but later on when installing)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)

# add the automatically determined parts of the RPATH
# which point to directories outside the build tree to the install RPATH
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
