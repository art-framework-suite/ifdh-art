
include_directories(../IFDHService) ### MIGRATE-ACTION-RECOMMENDED: use target_link_directories() with target semantics

simple_plugin(IFFileTransfer "service" 
			   ${IFDH} 
                           ${ART_FRAMEWORK_CORE}
                           art::Utilities
                           messagefacility::MF_MessageLogger
			   fhiclcpp::fhiclcpp
                           cetlib::cetlib ${CETLIB_EXCEPT}
                           ${ROOT_BASIC_LIB_LIST}
                           Boost::filesystem
              BASENAME_ONLY
           )

install_ifdh_headers()
install_source()

