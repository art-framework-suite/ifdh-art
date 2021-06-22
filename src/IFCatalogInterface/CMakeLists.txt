
simple_plugin(IFCatalogInterface "service" 
			   ${IFDH} 
                           ${ART_FRAMEWORK_CORE}
                           art::Utilities
                           messagefacility::MF_MessageLogger
			   fhiclcpp::fhiclcpp
                           cetlib::cetlib ${CETLIB_EXCEPT}
                           Boost::filesystem
                           ${ROOT_BASIC_LIB_LIST}
              BASENAME_ONLY
		)
include_directories(../IFDHService) ### MIGRATE-ACTION-RECOMMENDED: use target_link_directories() with target semantics

install_ifdh_headers()
install_source()

