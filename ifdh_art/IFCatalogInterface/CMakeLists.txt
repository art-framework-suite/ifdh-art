
simple_plugin(IFCatalogInterface "service" 
              LIBRARIES
			   ${IFDH} 
                           ${ART_FRAMEWORK_CORE}
                           art::Utilities
                           messagefacility::MF_MessageLogger
			   fhiclcpp::fhiclcpp
                           cetlib::cetlib
                           Boost::filesystem
                           ${ROOT_BASIC_LIB_LIST}
              BASENAME_ONLY
		)
include_directories(../IFDHService) ### MIGRATE-ACTION-RECOMMENDED: use target_link_directories() with target semantics

install_headers()
install_source()

