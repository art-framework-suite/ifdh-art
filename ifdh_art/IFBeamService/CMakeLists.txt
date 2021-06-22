


simple_plugin(IFBeam "service" 
              LIBRARIES
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

install_headers()
install_source()

