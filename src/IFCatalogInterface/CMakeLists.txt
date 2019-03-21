
simple_plugin(IFCatalogInterface "service" 
			   ${IFDH} 
                           ${ART_FRAMEWORK_CORE}
                           ${ART_UTILITIES}
                           ${MF_MESSAGELOGGER}
                           ${MF_UTILITIES}
			   ${FHICLCPP}
                           ${CETLIB} ${CETLIB_EXCEPT}
                           ${Boost_FILESYSTEM_LIBRARY}
                           ${Boost_SYSTEM_LIBRARY}
                           ${ROOT_LIBRARIES}
              BASENAME_ONLY
		)
include_directories(../IFDHService)

install_ifdh_headers()
install_source()

