

simple_plugin(IFDH service 
              LIBRARIES
			   ${IFDH} 
			   art::Utilities
                           messagefacility::MF_MessageLogger
			   fhiclcpp::fhiclcpp
                           cetlib::cetlib
                           Boost::filesystem
              BASENAME_ONLY
             )

install_headers()
install_source()

