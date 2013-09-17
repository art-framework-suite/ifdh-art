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

# cetbuildtools contains our cmake modules
SET ( CETBUILDTOOLS_VERSION $ENV{CETBUILDTOOLS_VERSION} )
IF (NOT CETBUILDTOOLS_VERSION)
    MESSAGE (FATAL_ERROR "ERROR: setup cetbuildtools to get the cmake modules")
ENDIF()
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/Modules 
                      $ENV{CETBUILDTOOLS_DIR}/Modules 
                      $ENV{ART_DIR}/Modules 
		      ${CMAKE_MODULE_PATH})

include(CetCMakeEnv)
cet_cmake_env()

#cet_set_compiler_flags(DIAGS VIGILANT WERROR NO_UNDEFINED EXTRA_FLAGS -pedantic)
#cet_set_compiler_flags(DIAGS VIGILANT WERROR NO_UNDEFINED EXTRA_FLAGS -pedantic)
cet_set_compiler_flags(DIAGS VIGILANT NO_UNDEFINED EXTRA_FLAGS -pedantic)
cet_set_compiler_flags(DIAGS VIGILANT NO_UNDEFINED EXTRA_FLAGS -pedantic)
cet_have_qual(e4 E4)
if ( E4 )
  cet_add_compiler_flags(CXX -std=c++11)
endif()
cet_have_qual(sse4 SSE4)
if ( SSE4 )
  cet_add_compiler_flags(CXX -msse2 -ftree-vectorizer-verbose=2)
endif()

cet_report_compiler_flags()

# these are minimum required versions, not the actual product versions
 find_ups_product( art v1_06_00 )
 find_ups_product( ifdhc v1_1_3 )


cet_check_gcc()

# include search path
# notice use of ENV to invoke an external variable
include_directories ( $ENV{LIBSIGCPP_INC}/sigc++-2.0 )
include_directories ( $ENV{LIBSIGCPP_LIB}/sigc++-2.0/include )
include_directories($ENV{IFDHC_DIR}/inc)
include_directories($ENV{ART_DIR}/include)
include_directories($ENV{BOOST_INC})
include_directories($ENV{CETLIB_INC})
include_directories($ENV{CPP0X_INC})
include_directories($ENV{CPPUNIT_INC})
include_directories($ENV{FHICLCPP_INC})
include_directories($ENV{MESSAGEFACILITY_INC})



# have to make sure cmake doesn't select the system libraries
# define libsigc
cet_find_library( SIGC    NAMES sigc-2.0  PATHS ENV LIBSIGCPP_LIB NO_DEFAULT_PATH )
# define cppunit
cet_find_library( CPPUNIT NAMES cppunit   PATHS ENV CPPUNIT_LIB   NO_DEFAULT_PATH )

#ifdhc
cet_find_library( IFDH NAMES ifdh PATHS $ENV{IFDHC_LIB} NO_DEFAULT_PATH )
cet_find_library( IFBEAM NAMES ifbeam PATHS $ENV{IFDHC_LIB} NO_DEFAULT_PATH )
cet_find_library( NUCONDB NAMES nucondb PATHS $ENV{IFDHC_LIB} NO_DEFAULT_PATH )

# SQLite
cet_find_library(SQLITE3 NAMES sqlite3 PATHS ENV SQLITE_LIB NO_DEFAULT_PATH)

cet_find_library(ARTFRAMEWORKCORE NAMES art_Framework_Core PATHS $ENV{ART_LIB} NO_DEFAULT_PATH) 
cet_find_library(ARTUTILITIES NAMES art_Utilities PATHS $ENV{ART_LIB} NO_DEFAULT_PATH) 

# macros for art_dictionary and simple_plugin
include(ArtDictionary)
include(BuildPlugins)

# tools (first)
add_subdirectory(src)

# packaging utility
include(UseCPack)