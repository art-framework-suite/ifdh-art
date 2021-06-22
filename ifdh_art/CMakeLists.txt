
macro( install_ifdh_headers   )
  _cet_check_inc_directory()
  set(header_install_dir ${${CETMODULES_CURRENT_PROJECT_NAME}_INCLUDE_DIR} )
  message( STATUS "install_ifdh_headers: headers will be installed in ${header_install_dir}" )
  FILE(GLOB headers [^.]*.h [^.]*.hh [^.]*.icc )
  if( headers )
    message( STATUS "installing headers ${headers} in ${header_install_dir}")
    INSTALL( FILES ${headers}
             DESTINATION ${header_install_dir} )
  endif( headers )
endmacro( install_ifdh_headers )

# not sure why this is necessary
include_directories($ENV{MESSAGEFACILITY_INC})
# need Find modules for nucondb, ifbeam, libwda, and ifdhc
include_directories($ENV{IFDHC_FQ_DIR}/inc)
include_directories($ENV{LIBWDA_FQ_DIR}/include)
include_directories($ENV{IFBEAM_FQ_DIR}/include)
include_directories($ENV{NUCONDB_FQ_DIR}/include)


# source
subdirs (IFDHService)
subdirs (IFBeamService)
subdirs (nucondbService)
subdirs (IFFileTransfer)
subdirs (IFCatalogInterface)
subdirs (bin)

