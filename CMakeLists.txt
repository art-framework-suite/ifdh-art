# ======================================================================
#  art main build file
#
#  cd .../path/to/build/directory
#  source .../path/to/art/ups/setup_for_development
#  cmake [-DCMAKE_INSTALL_PREFIX=/install/path]
#        -DCMAKE_BUILD_TYPE=$CETPKG_TYPE
#        $CETPKG_SOURCE
#  make
#  make test
#  make install
#  make package (builds distribution tarfile)
# ======================================================================

# use cmake 3.11 or later
cmake_minimum_required (VERSION 3.11)


project(ifdh_art VERSION 2.08.00 LANGUAGES CXX )

find_package(cetmodules 1.02.03)
include(CetCMakeEnv)
cet_cmake_env()

cet_set_compiler_flags(DIAGS VIGILANT
  WERROR
  NO_UNDEFINED
  EXTRA_FLAGS -pedantic
)

cet_report_compiler_flags()

cet_find_simple_package(ifbeam)
cet_find_simple_package(ifdh INCPATH_SUFFIXES inc)
cet_find_simple_package(nucondb)
cet_find_simple_package(wda)
cet_find_simple_package(sqlite3)
find_package(cetlib_except REQUIRED)
find_package(art REQUIRED)

# macros
include(ArtMake)
include(BuildPlugins)

add_subdirectory (src)
#add_subdirectory (tests)
#add_subdirectory (ups)
add_subdirectory(cmakeConfig)

# packaging utility
#include(UseCPack)
