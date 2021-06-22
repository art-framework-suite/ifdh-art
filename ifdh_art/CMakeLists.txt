
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

