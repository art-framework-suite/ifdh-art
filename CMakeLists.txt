# ======================================================================
#  ifdh_art main build file
#
# ======================================================================
cmake_minimum_required(VERSION 3.19 FATAL_ERROR)

find_package(cetmodules 2.29.07 REQUIRED)
project(ifdh_art VERSION 2.18.02 LANGUAGES CXX)

include(CetCMakeEnv)
cet_cmake_env()

cet_set_compiler_flags(DIAGS VIGILANT
  WERROR
  NO_UNDEFINED
  EXTRA_FLAGS -pedantic
)

cet_report_compiler_flags(REPORT_THRESHOLD VERBOSE)

find_package(art REQUIRED)
find_package(libwda REQUIRED)
find_package(ifdhc REQUIRED EXPORT)
find_package(ifbeam REQUIRED EXPORT)
find_package(nucondb REQUIRED EXPORT)
find_package(cetlib_except REQUIRED)

# macros
include(ArtMake)
include(BuildPlugins)

add_subdirectory (ifdh_art)
#add_subdirectory (tests)

# packaging utility
cet_cmake_config()
