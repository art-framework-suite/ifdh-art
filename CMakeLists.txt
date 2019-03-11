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
cmake_minimum_required (VERSION 3.11)


project(ifdh_art VERSION 2.08.00 LANGUAGES CXX )

find_package( cetmodules )
include(CetCMakeEnv)
cet_cmake_env()

cet_set_compiler_flags(DIAGS VIGILANT
  WERROR
  NO_UNDEFINED
  EXTRA_FLAGS -pedantic
)

cet_report_compiler_flags()

find_package( art REQUIRED)
find_package( ifdhc  )
find_package( ifbeam  )
find_package( nucondb  )
find_package( libwda  )
find_package( cetlib_except REQUIRED)
find_package( messagefacility REQUIRED)
# include search path
# decide if we have IFDHC_FQ_DIR or IFDHC_DIR
if ( ${IFDHC_FQ_DIR} MATCHES "ifdhc" )
  message(STATUS "using FQ_DIR")
  include_directories(${IFDHC_FQ_DIR}/inc)
  include_directories(${LIBWDA_FQ_DIR}/include)
  include_directories(${IFBEAM_FQ_DIR}/include)
  include_directories(${NUCONDB_FQ_DIR}/include)
else()
  message(STATUS "using DIR")
  include_directories(${IFDHC_DIR}/inc)
  include_directories(${LIBWDA_DIR}/include)
  include_directories(${IFBEAM_DIR}/include)
  include_directories(${NUCONDB_DIR}/include)
endif()

#ifdhc
cet_find_library( IFDH    NAMES ifdh    PATHS  ${IFDHC_DIR}/lib   NO_DEFAULT_PATH )
cet_find_library( IFBEAM  NAMES ifbeam  PATHS  ${IFBEAM_DIR}/lib  NO_DEFAULT_PATH )
cet_find_library( NUCONDB NAMES nucondb PATHS  ${NUCONDB_DIR}/lib NO_DEFAULT_PATH )
cet_find_library( WDA     NAMES wda     PATHS  ${LIBWDA_DIR}/lib  NO_DEFAULT_PATH )

# SQLite
cet_find_library(SQLITE3 NAMES sqlite3 PATHS  SQLITE_LIB NO_DEFAULT_PATH)

# macros for art_dictionary and simple_plugin
include(ArtDictionary)
include(ArtMake)
include(BuildPlugins)

add_subdirectory (src)
#add_subdirectory (tests)
#add_subdirectory (ups)
add_subdirectory(cmakeConfig)

# packaging utility
#include(UseCPack)
