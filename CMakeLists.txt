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
# use cmake 3.12 or later
cmake_minimum_required(VERSION 3.19 FATAL_ERROR)


find_package(cetmodules 2.18.03 REQUIRED)
project(ifdh_art VERSION 2.12.03 LANGUAGES CXX)

include(CetCMakeEnv)
cet_cmake_env()

cet_set_compiler_flags(DIAGS VIGILANT
  WERROR
  NO_UNDEFINED
  EXTRA_FLAGS -pedantic
)

cet_report_compiler_flags(REPORT_THRESHOLD VERBOSE)

cet_find_package( art REQUIRED)
cet_find_package(cetlib_except REQUIRED)
cet_find_package(messagefacility REQUIRED)
cet_find_package(Boost COMPONENTS filesystem REQUIRED)
find_ups_product( ifdhc  ) ### MIGRATE-ACTION-RECOMMENDED: use cet_find_package() with target semantics for linking
find_ups_product( ifbeam  ) ### MIGRATE-ACTION-RECOMMENDED: use cet_find_package() with target semantics for linking
find_ups_product( nucondb  ) ### MIGRATE-ACTION-RECOMMENDED: use cet_find_package() with target semantics for linking
find_ups_product( libwda  ) ### MIGRATE-ACTION-RECOMMENDED: use cet_find_package() with target semantics for linking


#ifdhc
cet_find_library( IFDH    NAMES ifdh    PATHS ENV IFDHC_LIB   NO_DEFAULT_PATH ) ### MIGRATE-ACTION-RECOMMENDED: use of ENV ... may be UPS-dependent ### MIGRATE-ACTION-RECOMMENDED: use cet_find_package() with target semantics for linking
cet_find_library( IFBEAM  NAMES ifbeam  PATHS ENV IFBEAM_LIB  NO_DEFAULT_PATH ) ### MIGRATE-ACTION-RECOMMENDED: use of ENV ... may be UPS-dependent ### MIGRATE-ACTION-RECOMMENDED: use cet_find_package() with target semantics for linking
cet_find_library( NUCONDB NAMES nucondb PATHS ENV NUCONDB_LIB NO_DEFAULT_PATH ) ### MIGRATE-ACTION-RECOMMENDED: use of ENV ... may be UPS-dependent ### MIGRATE-ACTION-RECOMMENDED: use cet_find_package() with target semantics for linking
cet_find_library( WDA     NAMES wda     PATHS ENV LIBWDA_LIB  NO_DEFAULT_PATH ) ### MIGRATE-ACTION-RECOMMENDED: use of ENV ... may be UPS-dependent ### MIGRATE-ACTION-RECOMMENDED: use cet_find_package() with target semantics for linking

# macros
include(ArtMake)
include(BuildPlugins)

add_subdirectory (ifdh_art)
#add_subdirectory (tests)

# packaging utility
cet_cmake_config()
