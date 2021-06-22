
include_directories(../IFDHService) ### MIGRATE-ACTION-RECOMMENDED: use target_link_directories() with target semantics

simple_plugin(IFFileTransfer "service" 
              LIBRARIES
			   ${IFDH} 
                           ${ART_FRAMEWORK_CORE}
                           art::Utilities
                           messagefacility::MF_MessageLogger
			   fhiclcpp::fhiclcpp
                           cetlib::cetlib
                           ${ROOT_BASIC_LIB_LIST}
                           Boost::filesystem
              BASENAME_ONLY
           )

install_headers()
install_source()

