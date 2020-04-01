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

# use cmake 2.8 or later
cmake_minimum_required (VERSION 2.8)

##SET ( CMAKE_VERBOSE_MAKEFILE true )
# cetbuildtools contains our cmake modules
SET ( CETBUILDTOOLS_VERSION $ENV{CETBUILDTOOLS_VERSION} )
IF (NOT CETBUILDTOOLS_VERSION)
    MESSAGE (FATAL_ERROR "ERROR: setup cetbuildtools to get the cmake modules")
ENDIF()

set(CMAKE_MODULE_PATH $ENV{ART_DIR}/Modules
		      $ENV{CETBUILDTOOLS_DIR}/Modules
		      ${CMAKE_MODULE_PATH})

include(CetCMakeEnv)
cet_cmake_env()

cet_set_compiler_flags(DIAGS VIGILANT
  WERROR
  NO_UNDEFINED
  EXTRA_FLAGS -pedantic
)

cet_report_compiler_flags()

find_ups_product( art )
find_ups_product( ifdhc  )
find_ups_product( ifbeam  )
find_ups_product( nucondb  )
find_ups_product( libwda  )
find_ups_product( cetbuildtools  )
find_ups_product( cetlib_except )

# include search path
# decide if we have IFDHC_FQ_DIR or IFDHC_DIR
if ( $ENV{IFDHC_FQ_DIR} MATCHES "ifdhc" )
  message(STATUS "using FQ_DIR")
  include_directories($ENV{IFDHC_FQ_DIR}/inc)
  include_directories($ENV{LIBWDA_FQ_DIR}/include)
  include_directories($ENV{IFBEAM_FQ_DIR}/include)
  include_directories($ENV{NUCONDB_FQ_DIR}/include)
else()
  message(STATUS "using DIR")
  include_directories($ENV{IFDHC_DIR}/inc)
  include_directories($ENV{LIBWDA_DIR}/include)
  include_directories($ENV{IFBEAM_DIR}/include)
  include_directories($ENV{NUCONDB_DIR}/include)
endif()

#ifdhc
cet_find_library( IFDH    NAMES ifdh    PATHS ENV IFDHC_LIB   NO_DEFAULT_PATH )
cet_find_library( IFBEAM  NAMES ifbeam  PATHS ENV IFBEAM_LIB  NO_DEFAULT_PATH )
cet_find_library( NUCONDB NAMES nucondb PATHS ENV NUCONDB_LIB NO_DEFAULT_PATH )
cet_find_library( WDA     NAMES wda     PATHS ENV LIBWDA_LIB  NO_DEFAULT_PATH )

# SQLite
cet_find_library(SQLITE3 NAMES sqlite3 PATHS ENV SQLITE_LIB NO_DEFAULT_PATH)

# macros
include(ArtMake)
include(BuildPlugins)

add_subdirectory (src)
#add_subdirectory (tests)
add_subdirectory (ups)
#cmakeConfig for cetmodules)
add_subdirecroty(cmakeConfig)
# packaging utility
include(UseCPack)
