# this one is important
SET(CMAKE_SYSTEM_NAME Linux)
#this one not so much
SET(CMAKE_SYSTEM_VERSION 1)

# specify the cross compiler
SET(PL_TOOLS_ROOT        /opt/pl-build-tools)
SET(PL_INSTALL_ROOT      /opt/puppetlabs/puppet)
SET(CMAKE_INSTALL_PREFIX ${PL_INSTALL_ROOT} CACHE PATH "")
SET(CMAKE_C_COMPILER     ${PL_TOOLS_ROOT}/bin/gcc)
SET(CMAKE_CXX_COMPILER   ${PL_TOOLS_ROOT}/bin/g++)

# where is the target environment
SET(CMAKE_FIND_ROOT_PATH ${PL_TOOLS_ROOT} ${PL_INSTALL_ROOT})

# search for programs in the build host directories
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM BOTH)

# for libraries and headers in the target directories
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)

SET(CMAKE_C_FLAGS "-fPIC -pthread -I${PL_INSTALL_ROOT}/include -I${PL_TOOLS_PREFIX}/include ${CMAKE_C_FLAGS}" CACHE STRING "" FORCE)
SET(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS}" CACHE STRING "" FORCE)

# update RPATH so our custom libraries can be found
# use, i.e. don't skip the full RPATH for the build tree
SET(CMAKE_SKIP_BUILD_RPATH  FALSE)

# when building, don't use the install RPATH already
# (but later on when installing)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)

# add the automatically determined parts of the RPATH
# which point to directories outside the build tree to the install RPATH
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
