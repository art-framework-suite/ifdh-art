


simple_plugin(IFBeam "service" 
			   ${IFBEAM} 
                           ${WDA}
                           ${IFDH}
                           messagefacility::MF_MessageLogger
			   art::Utilities
			   fhiclcpp::fhiclcpp
                           cetlib::cetlib
                           Boost::filesystem
              BASENAME_ONLY
         )

install_ifdh_headers()
install_source()

